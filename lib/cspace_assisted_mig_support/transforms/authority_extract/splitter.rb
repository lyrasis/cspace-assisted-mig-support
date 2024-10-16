# frozen_string_literal: true

module CspaceAssistedMigSupport
  module Transforms
    module AuthorityExtract
      class Splitter
        VALUE_TARGET = :value
        FULL_TARGET = :full_value
        POS_TARGET = :pos
        DELIMS = [Cams.delim, Cams.authority_split_delims].flatten.freeze

        # @param value_target [Symbol]
        # @param full_target [Symbol]
        # @param pos_target [Symbol]
        # @param delims [Array[String]]
        def initialize(value_target: VALUE_TARGET,
                       full_target: FULL_TARGET,
                       pos_target: POS_TARGET,
                       delims: DELIMS)
          @value_target = value_target
          @full_target = full_target
          @pos_target = pos_target
          @delims = delims
        end

        def process(row)
          val = row[value_target]

          newrow = row.dup
          newrow[full_target] = newrow.delete(value_target)
          split_vals(val).flatten
            .each_with_index do |ival, idx|
            yield newrow.merge({value_target => ival, pos_target => idx})
          end

          nil
        end

        private

        attr_reader :value_target, :full_target, :pos_target, :delims

        def split_vals(str)
          return [str] if str.blank?

          delims.inject([str]) { |result, delim| split_val(result, delim) }
        end

        def split_val(val, delim)
          arr = [val].flatten

          arr.map { |str| str.split(delim) }
        end
      end
    end
  end
end
