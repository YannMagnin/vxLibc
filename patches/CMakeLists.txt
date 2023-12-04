# This cmake file will be dropped at the root of the openlibm repository
# folder and need to be as generic as possible to support further update
# of the original project
cmake_minimum_required(VERSION 3.5)

## fetch source files

file(
    GLOB
    VXLIBC_SOURCES

    # vhex-specific
    src/stdlib/target/vhex-sh/free.c
    src/stdlib/target/vhex-sh/malloc.c
    src/stdlib/target/vhex-sh/realloc.c

    # sh-specific
    src/setjmp/target/sh-generic/setjmp.S
    src/setjmp/target/sh-generic/longjmp.S
    src/string/target/sh-generic/memchr.S
    src/string/target/sh-generic/memcmp.S
    src/string/target/sh-generic/memcpy.S
    src/string/target/sh-generic/memmove.S
    src/string/target/sh-generic/memset.S
    src/string/target/sh-generic/strlen.S
    src/target/sh-generic/cpucap.c

    # 3rdparty
    3rdparty/grisu2b_59_56/grisu2b_59_56.c
    3rdparty/tinymt32/rand.c
    3rdparty/tinymt32/tinymt32.c

    # C++ API details
    src/dso.c

    # assert
    src/assert/assert.c

    # ctype
    src/ctype/isalnum.c
    src/ctype/isalpha.c
    src/ctype/isblank.c
    src/ctype/iscntrl.c
    src/ctype/isdigit.c
    src/ctype/isgraph.c
    src/ctype/islower.c
    src/ctype/isprint.c
    src/ctype/ispunct.c
    src/ctype/isspace.c
    src/ctype/isupper.c
    src/ctype/isxdigit.c
    src/ctype/tolower.c
    src/ctype/toupper.c

    # errno
    src/errno/errno.c

    # inttypes
    src/inttypes/imaxabs.c
    src/inttypes/imaxdiv.c
    src/inttypes/strtoimax.c
    src/inttypes/strtoumax.c

    # locale
    src/locale/setlocale.c
    src/locale/localeconv.c

    # signal
    src/signal/signal.c
    src/signal/raise.c

    # stdio
    src/stdio/asprintf.c
    src/stdio/clearerr.c
    src/stdio/dprintf.c
    src/stdio/fclose.c
    src/stdio/fdopen.c
    src/stdio/ferror.c
    src/stdio/feof.c
    src/stdio/fflush.c
    src/stdio/fgetc.c
    src/stdio/fgetpos.c
    src/stdio/fgets.c
    src/stdio/fileno.c
    src/stdio/fileutil.c
    src/stdio/fopen.c
    src/stdio/fprintf.c
    src/stdio/fputc.c
    src/stdio/fputs.c
    src/stdio/fread.c
    src/stdio/freopen.c
    src/stdio/fseek.c
    src/stdio/fsetpos.c
    src/stdio/ftell.c
    src/stdio/fwrite.c
    src/stdio/getc.c
    src/stdio/getchar.c
    src/stdio/gets.c
    src/stdio/getline.c
    src/stdio/getdelim.c
    src/stdio/perror.c
    src/stdio/printf.c
    src/stdio/printf/format_fixed.c
    src/stdio/printf/format_fp.c
    src/stdio/printf/format_usual.c
    src/stdio/printf/print.c
    src/stdio/printf/util.c
    src/stdio/putc.c
    src/stdio/putchar.c
    src/stdio/puts.c
    src/stdio/remove.c
    src/stdio/rewind.c
    src/stdio/scanf/scan.c
    src/stdio/setbuf.c
    src/stdio/setvbuf.c
    src/stdio/snprintf.c
    src/stdio/sprintf.c
    src/stdio/streams.c
    src/stdio/ungetc.c
    src/stdio/vasprintf.c
    src/stdio/vdprintf.c
    src/stdio/vfprintf.c
    src/stdio/vprintf.c
    src/stdio/vsnprintf.c
    src/stdio/vsprintf.c

    # stdlib
    src/stdlib/abort.c
    src/stdlib/abs.c
    src/stdlib/atexit.c
    src/stdlib/atof.c
    src/stdlib/atoi.c
    src/stdlib/atol.c
    src/stdlib/atoll.c
    src/stdlib/calloc.c
    src/stdlib/div.c
    src/stdlib/exit.c
    src/stdlib/labs.c
    src/stdlib/ldiv.c
    src/stdlib/llabs.c
    src/stdlib/lldiv.c
    src/stdlib/qsort.c
    src/stdlib/reallocarray.c
    src/stdlib/strto_fp.c
    src/stdlib/strto_int.c
    src/stdlib/strtod.c
    src/stdlib/strtof.c
    src/stdlib/strtol.c
    src/stdlib/strtold.c
    src/stdlib/strtoll.c
    src/stdlib/strtoul.c
    src/stdlib/strtoull.c

    # string
    src/string/memchr.c
    src/string/memcmp.c
    src/string/memcpy.c
    src/string/memmove.c
    src/string/memrchr.c
    src/string/memset.c
    src/string/strcasecmp.c
    src/string/strcasestr.c
    src/string/strcat.c
    src/string/strchr.c
    src/string/strchrnul.c
    src/string/strcmp.c
    src/string/strcoll.c
    src/string/strcpy.c
    src/string/strcspn.c
    src/string/strdup.c
    src/string/strerror.c
    src/string/strlen.c
    src/string/strncasecmp.c
    src/string/strncat.c
    src/string/strncmp.c
    src/string/strncpy.c
    src/string/strndup.c
    src/string/strnlen.c
    src/string/strpbrk.c
    src/string/strrchr.c
    src/string/strspn.c
    src/string/strstr.c
    src/string/strstr_base.c
    src/string/strtok.c
    src/string/strxfrm.c

    # time
    src/time/asctime.c
    src/time/ctime.c
    src/time/difftime.c
    src/time/gmtime.c
    src/time/localtime.c
    src/time/mktime.c
    src/time/strftime.c
)

## generate projects

project(vxlibc LANGUAGES C ASM)
set_property(GLOBAL PROPERTY TARGET_SUPPORTS_SHARED_LIBS TRUE)
add_compile_options(
    -D__SUPPORT_VHEX_KERNEL=1
    -D__SUPPORT_ARCH_SH=1
    "$<$<COMPILE_LANGUAGE:C>:-m3;-mb>"
    "$<$<COMPILE_LANGUAGE:ASM>:-m4-nofpu;-mb;-Wa,--dsp>"
    -Wall
    -Wextra
    -std=c11
    -ffreestanding
    -nostdlib
    -fPIC
    -Os
)
include_directories(
    include/
    include/target/vhex/
    include/target/sh-generic/
    "${CMAKE_INSTALL_PREFIX}/include/"
)
add_library(vxlibcStatic STATIC ${VXLIBC_SOURCES})
add_library(vxlibcShared SHARED ${VXLIBC_SOURCES})

## install process

set_target_properties(vxlibcStatic PROPERTIES OUTPUT_NAME "c")
set_target_properties(vxlibcShared PROPERTIES OUTPUT_NAME "c")

install(TARGETS vxlibcStatic DESTINATION lib)
install(TARGETS vxlibcShared DESTINATION lib)

install(DIRECTORY include/ DESTINATION include PATTERN "target" EXCLUDE)
install(DIRECTORY include/target/vhex DESTINATION include/target)
install(DIRECTORY include/target/sh-generic DESTINATION include/target)
