# -*- encoding: utf-8 -*-
begin
  require 'byebug'
rescue LoadError
end
require_relative '../test_helper'

class KeyPickerFilterTest < Test::Unit::TestCase

  TEST_RECORD = {'foo' => 'a', 'bar' => 'b', 'baz' => 'c'}
  EMPTY_HASH = {}

  def setup
    Fluent::Test.setup
  end

  def create_driver(conf, tag = 'test')
    Fluent::Test::FilterTestDriver.new(
      Fluent::KeyPickerFilter, tag
    ).configure(conf)
  end

  def test_configure
    d = create_driver(%[
      keys           foo, bar
    ])
    assert_equal ['foo', 'bar'], d.instance.keys

    #No Keys
    assert_raise(Fluent::ConfigError) do
      create_driver(%[
      ])
    end

    #0 length keys
    assert_raise(Fluent::ConfigError) do
      create_driver(%[
        keys
      ])
    end
  end

  def test_no_matching_record
    d = create_driver(%[
      keys           foo, bar
    ])

    tag    = 'test'
    record = {}

    assert_equal record, {}
  end

  def test_emit
    d = create_driver(%[
      keys           foo, bar
    ])

    d.run { d.emit(TEST_RECORD.dup) }
    emits = d.filtered_as_array

    assert_equal 1, emits.count
    assert_equal 'test', emits[0][0]
    assert_equal 'a', emits[0][2]['foo']
    assert_equal 'b', emits[0][2]['bar']
  end

  def test_emit_multi
    d = create_driver(%[
      keys           foo, bar
    ])
    d.run do
      d.emit(TEST_RECORD.dup)
      d.emit(TEST_RECORD.dup)
      d.emit(TEST_RECORD.dup)
    end
    emits = d.filtered_as_array

    assert_equal 3, emits.count

    emits.each do |e|
      assert_equal 'test', e[0]
      assert_equal 'a', e[2]['foo']
      assert_equal 'b', e[2]['bar']
    end
  end

  def test_emit_without_match_key
    d = create_driver(%[
      keys           fiz, faz
    ])
    d.run { d.emit(TEST_RECORD.dup) }
    emits = d.filtered_as_array

    assert_equal 1, emits.count
    assert_equal 'test', emits[0][0]
    assert_equal EMPTY_HASH, emits[0][2]
  end

end
