require File.dirname(__FILE__) + '/../test_helper'

#require 'test_helper'

class CreditcardTest < ActiveSupport::TestCase


  fixtures :creditcards

  def test_creditcard

    creditcard = Creditcard.new :number => creditcards(:visa).number,
                                :expdate => creditcards(:visa).expdate,
                                :code => creditcards(:visa).code,
                                :name => creditcards(:visa).name,
                                :client_id => creditcards(:visa).client_id
    assert !creditcard.save

    creditcard.number = 8888888888888889
    assert creditcard.save

    creditcard_copy = Creditcard.find(creditcard.id)

    assert_equal creditcard.code, creditcard_copy.code

    creditcard.name = "Francisco Perez"

    assert creditcard.save
    assert creditcard.destroy
  end
end
