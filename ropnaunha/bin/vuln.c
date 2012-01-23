#include <string.h>
int
main(int argc, char ** argv)
{
  char buffer[256];
  if (argc < 2)
    return 1;
  strcpy(buffer, argv[1]);
  return 0;
}
