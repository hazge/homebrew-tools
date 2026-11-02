#include <CoreAudio/CoreAudio.h>
#include <CoreFoundation/CoreFoundation.h>
#include <errno.h>
#include <libgen.h>
#include <limits.h>
#include <mach-o/dyld.h>
#include <signal.h>
#include <spawn.h>
#include <stdio.h>
#include <string.h>
#include <sys/wait.h>

extern char **environ;

static volatile pid_t child;

static void forward(int sig) {
    if (child > 0) kill(child, sig);
}

static int remove_device(void) {
    CFStringRef uid = CFSTR("com.hazge.voxlock-mic.aggregate");
    AudioObjectPropertyAddress address = {
        kAudioHardwarePropertyTranslateUIDToDevice,
        kAudioObjectPropertyScopeGlobal,
        kAudioObjectPropertyElementMain,
    };
    AudioObjectID device = kAudioObjectUnknown;
    UInt32 size = sizeof device;
    OSStatus err = AudioObjectGetPropertyData(kAudioObjectSystemObject, &address, sizeof uid, &uid, &size, &device);
    if (err != noErr || device == kAudioObjectUnknown) {
        printf("VoxLock Microphone not found\n");
        return 0;
    }
    err = AudioHardwareDestroyAggregateDevice(device);
    if (err != noErr) {
        fprintf(stderr, "could not remove VoxLock Microphone: CoreAudio error %d\n", (int)err);
        return 1;
    }
    printf("removed VoxLock Microphone\n");
    return 0;
}

int main(int argc, char **argv) {
    if (argc > 1 && strcmp(argv[1], "--remove-device") == 0) return remove_device();

    char exe[PATH_MAX];
    uint32_t size = sizeof exe;
    if (_NSGetExecutablePath(exe, &size) != 0) return 1;
    char script[PATH_MAX];
    snprintf(script, sizeof script, "%s/../Resources/run.sh", dirname(exe));

    sigset_t forwarded, previous, empty;
    sigemptyset(&forwarded);
    sigaddset(&forwarded, SIGTERM);
    sigaddset(&forwarded, SIGINT);
    sigaddset(&forwarded, SIGHUP);
    sigemptyset(&empty);
    sigprocmask(SIG_BLOCK, &forwarded, &previous);

    struct sigaction action = {0};
    action.sa_handler = forward;
    action.sa_flags = SA_RESTART;
    sigaction(SIGTERM, &action, NULL);
    sigaction(SIGINT, &action, NULL);
    sigaction(SIGHUP, &action, NULL);
    signal(SIGCHLD, SIG_DFL);

    posix_spawnattr_t attr;
    posix_spawnattr_init(&attr);
    posix_spawnattr_setsigmask(&attr, &empty);
    posix_spawnattr_setflags(&attr, POSIX_SPAWN_SETSIGMASK);
    char *child_argv[] = {"/bin/bash", script, NULL};
    pid_t pid;
    int spawned = posix_spawn(&pid, "/bin/bash", NULL, &attr, child_argv, environ);
    posix_spawnattr_destroy(&attr);
    if (spawned != 0) return 1;
    child = pid;
    sigprocmask(SIG_SETMASK, &previous, NULL);

    int status = 0;
    while (waitpid(pid, &status, 0) < 0) {
        if (errno != EINTR) return 1;
    }
    return WIFEXITED(status) ? WEXITSTATUS(status) : 1;
}
