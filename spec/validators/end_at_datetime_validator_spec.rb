# frozen_string_literal: true

require 'rails_helper'

class EndAtDatetimeValidatable
  include ActiveModel::Validations
  attr_accessor :start_at, :end_at

  validates :end_at, end_at_datetime: true
end

describe EndAtDatetimeValidator do
  subject { EndAtDatetimeValidatable.new }

  context 'with a valid end_at' do
    it 'should be valid' do
      subject.start_at = Time.current + 1.hour
      subject.end_at = Time.current + 2.hours
      expect(subject.valid?).to eq true
    end
  end

  context 'with a invalid end_at' do
    it 'should be invalid' do
      subject.start_at = Time.current + 1.hour
      subject.end_at = Time.current
      expect(subject.valid?).to eq false
    end
  end
end
