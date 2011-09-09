require 'mongo'

class Event
  def initialize(customer_id)
    @conn = Mongo::Connection.new
    @db   = @conn['agiletask']
    @coll = @db['events']
    @customer_id = customer_id
  end

  def delete_all
    @coll.remove
  end

  def save(name, count = 1, created_at = Time.now)
    doc = {customer_id: @customer_id, created_at: created_at,
            name: name, count: count}
    @coll.insert(doc)
    doc
  end

  def save_doc(doc, created_at = Time.now)
    event = {customer_id: @customer_id, created_at: created_at}
    event[:data] = doc
    @coll.insert(event)
    event
  end

  def get_total_count(name)
    count = 0
    @coll.find({name: name}).to_a.each do |doc|
      count += doc['count']
    end
    count
  end
end