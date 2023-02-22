/* user and group to drop privileges to */
static const char *user  = "root";
static const char *group = "root";

static const char *colorname[NUMCOLS] = {
	[INIT] =   "black",     /* after initialization */
	[INPUT] =  "#005577",   /* during input */
	[FAILED] = "#FF6347",   /* wrong password */
};

/* treat a cleared input like a wrong password (color) */
static const int failonclear = 1;
