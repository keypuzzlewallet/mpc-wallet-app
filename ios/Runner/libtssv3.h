// NOTE: Append the lines below to ios/Classes/<your>Plugin.h

#define const_max_nonce_per_refresh 100

char *c_sign(const char *c_request);

void c_keygen(const char *c_request);

void c_generate_nonce(const char *c_request);
