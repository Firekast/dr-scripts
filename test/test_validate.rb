require 'minitest/autorun'
require 'yaml'
require 'ostruct'
load 'test/test_harness.rb'

class TestValidate < Minitest::Test
  include Harness

  def setup
    $test_settings = nil
    $warn_msgs = []
    $error_msgs = []
  end

  def setup_settings(settings)
    $test_settings = OpenStruct.new(settings)
  end


  def test_parse_args
    setup_settings({})
    load('validate.lic')

    assert_equal 'test', $settings_called_with, 'Expected settings to be called with flex args'
  end

  def test_root_key_warnings
    setup_settings({})
    load('validate.lic')

    assert_equal 5, $warn_msgs.size, 'Expected one warning per root key'
  end

  def test_gear_set_item_existence
    setup_settings({"gear"=> [
        {
          :adjective=> "chain", :name=> "balaclava",
        },
        {
          :adjective=> "mail", :name=> "gloves",
        },
        {
          :adjective=> "small", :name=> "shield",
        }
      ],
      "gear_sets"=> {
        "standard"=> [
          "chain balaclava",
          "mail gloves",
          "small shield",
          "padded hauberk"
        ]
      }
    })

    load('validate.lic')

    assert $error_msgs.grep(/padded hauberk/), 'Expected warning for missing item'
  end
end