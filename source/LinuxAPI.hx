#if LinuxSystems
@:headerCode('
#include <stdio.h>
')
#end
class LinuxAPI {
        #if linuxSystems
	@:functionCode('
	FILE *meminfo = fopen("/proc/meminfo", "r");

    	if(meminfo == NULL)
			return -1;

    	char line[256];
    	while(fgets(line, sizeof(line), meminfo))
    	{
        	int ram;
        	if(sscanf(line, "MemTotal: %d kB", &ram) == 1)
        	{
            	fclose(meminfo);
            	return (ram / 1024);
        	}
    	}

    	fclose(meminfo);
    	return -1;
	')
        #end
        // get ram amount on android/linux
	public static function getRAMonLinuxSystems()
	{
		return -1;
	}
}
