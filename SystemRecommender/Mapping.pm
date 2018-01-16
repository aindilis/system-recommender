package SystemRecommender::Mapping;

our $mappings =
  {
   'ow' => {
	    SourceName => 'Objectweb',
	    KeyName => 'proj_unixname',
	    ShortName => 'ow_projects.proj_unixname',
	    LongName => 'ow_projects.proj_long_name',
	    ShortDesc => 'ow_project_description.description', # or is this short desc
	    URLField => 'fsf_projects.url',
	   },
   'fsf' => {
	     SourceName => 'Free Software Foundation Directory',
	     KeyName => 'proj_num',
	     ShortName => 'fsf_projects.proj_unixname',
	     LongName => 'fsf_projects.proj_long_name',
	     ShortDesc => 'fsf_projects.desc_short',
	     LongDesc => 'fsf_projects.desc_long',
	     URLField => 'fsf_projects.url',
	     URLPattern => 'http://directory.fsf.org/wiki/<PROJNAME>',
	    },
   'sf' => {
	    SourceName => 'Sourceforge',
	    KeyName => 'proj_unixname',
	    ShortName => 'projects.proj_unixname',
	    LongName => 'projects.proj_long_name',
	    ShortDesc => 'projects.proj_description',
	    LongDesc => 'project_description.description',
	    URLField => 'projects.url',
	    URLPattern => 'http://sourceforge.net/projects/<PROJNAME>',
	    RADARMethod => 'SourceForge',
	   },
   'sv' => {
	    SourceName => 'Savannah',
	    KeyName => 'project_name',
	    ShortName => 'sv_projects.project_name',
	    LongDesc => 'sv_projects.description',
	    URLPattern => 'http://savannah.nongnu.org/projects/<PROJNAME>',
	   },
   'tig' => {
	     SourceName => 'Tigris',
	     KeyName => 'unixname',
	     ShortName => 'tig_projects.unixname',
	     ShortDesc => 'tig_projects.description',
	     URLPattern => 'http://<PROJNAME>.tigris.org/',
	    },
   'fm' => {
	    SourceName => 'Freshmeat',
	    KeyName => 'project_id',
	    ShortName => 'fm_projects.projectname_short',
	    LongName => 'fm_projects.projectname_full',
	    ShortDesc => 'fm_projects.desc_short',
	    LongDesc => 'fm_projects.desc_full',
	    URLField => 'fm_projects.url_project_page',
	    URLPattern => 'http://freecode.com/projects/<PROJNAME>',
	    RADARMethod => 'Freshmeat',
	   },
   'rf' => {
	    SourceName => 'Rubyforge',
	    KeyName => 'proj_unixname',
	    ShortName => 'rf_projects.proj_unixname',
	    LongName => 'rf_projects.proj_long_name',
	    ShortDesc => 'rf_project_description.description',
	    URLField => 'rf_projects.url',
	    URLPattern => 'http://rubyforge.org/projects/<PROJNAME>',
	   },
   'deb_metrics' => {
		     SourceName => 'Debian Metrics',
		     KeyName => 'proj_unixname',
		     ShortName => 'debian_projects.proj_unixname',
		     LongName => 'debian_projects.proj_longname',
		     LongDesc => 'debian_projects.description',
		    },
   'gc' => {
	    SourceName => 'Google Code',
	    KeyName => 'proj_name',
	    ShortName => 'gc_projects.proj_name',
	    LongDesc => 'gc_projects.project_description',
	    URLPattern => 'http://code.google.com/p/<PROJNAME>',
	    RADARMethod => 'GoogleCode',
	   },
   'gh' => {
	    SourceName => 'Github',
	    KeyName => 'project_name',
	    ShortName => 'gh_projects.project_name',
	    LongDesc => 'gh_projects.my_xml',
	    URLField => 'gh_projects.url',
	   },
   'lp' => {
	    SourceName => 'Launchpad',
	    KeyName => 'name',
	    ShortName => 'lpd_projects.name',
	    LongDesc => 'description',
	    URLField => 'homepage_url',
	   },
  };

1;
