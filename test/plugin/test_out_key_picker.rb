# -*- encoding: utf-8 -*-
begin
  require 'byebug'
rescue LoadError
end
require_relative '../test_helper'

class KeyPickerOutputTest < Test::Unit::TestCase

  TEST_RECORD = {'foo' => 'a', 'bar' => 'b', 'baz' => 'c'}
  EMPTY_HASH = {}

  def setup
    Fluent::Test.setup
  end

  def create_driver(conf, tag = 'test')
    Fluent::Test::OutputTestDriver.new(
      Fluent::KeyPickerOutput, tag
    ).configure(conf)
  end

  def test_configure
    d = create_driver(%[
      keys           foo, bar
      add_tag_prefix picked.
    ])
    assert_equal ['foo', 'bar'], d.instance.keys
    assert_equal 'picked.', d.instance.add_tag_prefix

    #No Prefix
    assert_raise(Fluent::ConfigError) do
      create_driver(%[
        keys      foo, bar
      ])
    end

    #No Keys
    assert_raise(Fluent::ConfigError) do
      create_driver(%[
        add_tag_prefix picked.
      ])
    end

    #0 length keys
    assert_raise(Fluent::ConfigError) do
      create_driver(%[
        keys
        add_tag_prefix picked.
      ])
    end
  end

  def test_filter_record
    d = create_driver(%[
      keys           foo, bar
      add_tag_prefix picked.
    ])

    record = TEST_RECORD.dup
    d.instance.filter_record('test', Time.now, record)
    assert_equal record, {'foo' => 'a', 'bar' => 'b'}
    assert_equal record['foo'], 'a'
    assert_equal record['bar'], 'b'
  end


  def test_no_matching_record
    d = create_driver(%[
      keys           foo, bar
      add_tag_prefix picked.
    ])

    tag    = 'test'
    record = {}

    assert_equal record, {}
  end

  def test_emit
    d = create_driver(%[
      keys           foo, bar
      add_tag_prefix picked.
    ])

    d.run { d.emit(TEST_RECORD.dup) }
    emits = d.emits

    assert_equal 1, emits.count
    assert_equal 'picked.test', emits[0][0]
    assert_equal 'a', emits[0][2]['foo']
    assert_equal 'b', emits[0][2]['bar']
  end

  def test_emit_multi
    d = create_driver(%[
      keys           foo, bar
      add_tag_prefix picked.
    ])
    d.run do
      d.emit(TEST_RECORD.dup)
      d.emit(TEST_RECORD.dup)
      d.emit(TEST_RECORD.dup)
    end
    emits = d.emits

    assert_equal 3, emits.count

    emits.each do |e|
      assert_equal 'picked.test', e[0]
      assert_equal 'a', e[2]['foo']
      assert_equal 'b', e[2]['bar']
    end
  end

  def test_emit_without_match_key
    d = create_driver(%[
      keys           fiz, faz
      add_tag_prefix picked.
    ])
    d.run { d.emit(TEST_RECORD.dup) }
    emits = d.emits

    assert_equal 1, emits.count
    assert_equal 'picked.test', emits[0][0]
    assert_equal EMPTY_HASH, emits[0][2]
  end

end
