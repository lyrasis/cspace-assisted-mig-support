# frozen_string_literal: true

require "thor"

class Authority < Thor
  desc "extract_cleaned",
    "Given a source file, extracts loadable authority terms, produces a "\
    "todo list of find-replaces, and adds cleaned columns to a copy of "\
    "source file"
  def extract_cleaned
    invoke 'run:jobs', [], keys: %i[
                                    authority_extract__ingest
                                    authority_extract__todo
                                    authority_extract__cleaned_source
                                   ]
  end
end
