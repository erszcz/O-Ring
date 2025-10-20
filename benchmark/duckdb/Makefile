compile-results.sql: compile-results.lang.sql.in langs
	@rm -f $@; \
	for l in $$(cat langs); do \
		gsed "s/{lang}/$$l/g" $< >> $@; \
	done; \
	cat compile-results.bottom.sql.in >> $@

# vim: sw=4 ts=4 sts=4 noet
