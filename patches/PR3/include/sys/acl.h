#include_next <sys/acl.h>
#ifndef ACL_TYPE_ACCESS
  #define ACL_TYPE_ACCESS (ACL_ACCESS)
  typedef int acl_t;
#endif
