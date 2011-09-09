require_relative 'test_helper'

describe "Simple business events" do
  before do
    @event = Event.new 1
    @event.delete_all
  end
  
  it "should save customer ID" do
    ev = @event.save "Contact Us"
    ev[:customer_id].must_equal 1
  end
  
  it "should save time" do
    ev = @event.save "Contact Us"
    ev[:created_at].wont_be_nil
  end
  
  it "should save 4 contact business events" do
    @event.save "Contact Us"
    @event.save "Contact Us"
    @event.save "Contact Us"
    @event.save "Contact Us"
    @event.get_total_count("Contact Us").must_equal 4
  end
  
  it "should save an inventory business event" do
    part = "Keyboard Part"
    @event.save part, 4
    @event.save part, -2    
    @event.get_total_count(part).must_equal 2
  end
  
  it "should save an arbitrary document" do
    doc = {shipment_id: "D123YL", customer_id: "C763EF"}
    ev = @event.save_doc doc
    ev[:created_at].wont_be_nil
    ev[:customer_id].must_equal 1
    ev[:data].must_equal doc
  end
end