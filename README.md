This plugin adds language files with entries in English that are missing for a certain locale.

This way you can avoid ugly things like [nl.purge_reason] but just get the English text, which provides a much better user experience.

To generate a language file, run

`ruby generate.rb <lang>`

for instance `ruby generate.rb nl`

After generating the language files you need, run

`RUBY_GC_MALLOC_LIMIT=90000000 RAILS_ENV=production bundle exec rake assets:clean assets:precompile`


