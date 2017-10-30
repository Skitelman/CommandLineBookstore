##
# This module gives a class the ability to store and retrieve instances of the class in memory.
#
# The module expects any class implementing it to also implement a `self.data_store` method. This method
# grants access to a `Hash` whose keys are object `id`s and whose values are the objects themselves. It is
# recommended that this method is called as part of the initialization of an instance.
#
# The module also expects any class implementing it to implement a method `id` that grants access to each
# object's `id` attribute.
module MemoryModule
  module ClassMethods
    ##
    # Returns all instances of the object stored in memory.
    #
    def all
      data_store.values
    end

    ##
    # Returns object with `id` that is stored in memory.
    # If no such object exists, it returns `nil`.
    def find(id)
      data_store[id]
    end
  end

  def self.included(receiver)
    receiver.extend(ClassMethods)
  end

  private

  ##
  # This method creates creates a new unique `id` for an object, set's the object's id,
  # and then stores in object in the class data_store.
  #
  def add_to_database
    id = self.class.data_store.keys.sort.last.to_i + 1
    instance_variable_set(:@id, id)
    self.class.data_store[id] = self
  end
end
