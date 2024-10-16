# frozen_string_literal: true

RSpec.describe Cams::Transforms::AuthorityExtract::Splitter do
  subject(:xform) { described_class.new(**params) }

  describe "#process" do
    let(:result) do
      Kiba::StreamingRunner.transform_stream(input, xform)
        .map{ |row| row }
      end
    let(:params) { {delims: ["|", "^^"]} }
    let(:input) do
      [
        {value: "bat", source: "foo"},
        {value: nil, source: "foo"},
        {value: "", source: "foo"},
        {value: "pop|rock", source: "foo"},
        {value: "top^^sock", source: "foo"},
        {value: "a|b^^c", source: "foo"},
        {value: "d^^e|f", source: "foo"},
      ]
    end


      let(:expected) do
        [
          {pos: 0, value: "bat", full_value: "bat", source: "foo"},
          {pos: 0, value: nil, full_value: nil, source: "foo"},
          {pos: 0, value: "", full_value: "", source: "foo"},
          {pos: 0, value: "pop", full_value: "pop|rock", source: "foo"},
          {pos: 1, value: "rock", full_value: "pop|rock", source: "foo"},
          {pos: 0, value: "top", full_value: "top^^sock", source: "foo"},
          {pos: 1, value: "sock", full_value: "top^^sock", source: "foo"},
          {pos: 0, value: "a", full_value: "a|b^^c", source: "foo"},
          {pos: 1, value: "b", full_value: "a|b^^c", source: "foo"},
          {pos: 2, value: "c", full_value: "a|b^^c", source: "foo"},
          {pos: 0, value: "d", full_value: "d^^e|f", source: "foo"},
          {pos: 1, value: "e", full_value: "d^^e|f", source: "foo"},
          {pos: 2, value: "f", full_value: "d^^e|f", source: "foo"},
        ]
      end

      it "splits values as expected" do
        expect(result).to eq(expected)
      end
  end
end
