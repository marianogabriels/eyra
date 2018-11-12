require "spec_helper"
require 'ostruct'

class Movie
  attr_accessor :title,:year
  def initialize(title,year)
    @title = title
    @year = year
  end
end

class MovieSerializer
  include Eyra
  field :title,type: String
  field :year,type: Integer
  field :year_in_hex, type: String

  dump_format :year_in_hex do |object|
    object.year.to_i.to_s(16)
  end
end

describe Eyra do
  let(:dummy_movie) { Movie.new('The fight club', '1999')} 

  it "has a version number" do
    expect(Eyra::VERSION).not_to be nil
  end

  it { expect(MovieSerializer).to respond_to(:fields) }
  it { expect(MovieSerializer.fields).to be_a(Array) }

  describe Eyra::Field do
    it 'serialize strings'  do
      field = Eyra::Field.new('title',type: String)
      expect(field.serialize(dummy_movie)).to eq('The fight club')
    end

    it 'serialize integers'  do
      field = Eyra::Field.new('year',type: Integer)
      expect(field.serialize(dummy_movie)).to eq(1999)
    end
  end

  describe 'Serializer' do
    let(:serialize){ MovieSerializer.new(dummy_movie) }

    it 'is a movie' do
      expect(serialize.object).to be_a(Movie)
    end

    describe 'mappings' do
      it 'String' do
        expect(serialize.title).to eq('The fight club')
      end

      it 'Integer' do
        expect(serialize.year).to eq(1999)
      end

    end

    describe 'dump_format' do
      it 'serialize strings' do
        expect(serialize.as_json['title']).to eq('The fight club')
      end
    end
  end
end
