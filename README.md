Searches CSO for software that matches desired capability.  Uses a
primitive collaborative filtering implementation to rate software for
applicability to a specific purpose, and then finds related software.
Rate, filter, repeat.

Here are some sample purposes that seed the search.
<pre>
$VAR1 = {
          '1' => 'http://frdcsa.onshore.net/frdcsa/internal/kbfs/index.html',
          '0' => 'http://frdcsa.onshore.net/frdcsa/internal/gourmet',
          '2' => 'NetOwl Extractor is an automatic indexing system that finds and classifies key phrases in text, such as personal names, corporate names, place names, dates, and monetary expressions. NetOwl Extractor finds all mentions of a name and links names that refer to the same entity together. NetOwl Extracto\
r combines dynamic recognition with static look-up to achieve high accuracy and coverage at very high speed. NetOwl Extractor is based on advanced computational linguistic and natural language processing technology. By intelligently analyzing structure and context within text, NetOwl accurately identifies key informa\
tion.'
        };
</pre>
