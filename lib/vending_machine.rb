require_relative "cash_manager"
require_relative "drink_manager"

class VendingMachine

  def initialize
    @drink_manager = DrinkManager.new([[:coke, 120, 5], [:water, 100, 5], [:redbull, 200, 5]])
    @cash_manager = CashManager.new(@drink_manager)

    cash_manager_methods = @cash_manager.public_methods(false)
    drink_manager_methods = @drink_manager.public_methods(false) - cash_manager_methods

    # メソッド作成
    cash_manager_methods.each{ VendingMachine.define_methods(@cash_manager, _1)}
    drink_manager_methods.each{ VendingMachine.define_methods(@drink_manager, _1)}
  end

  def self.define_methods(object, method)
    define_method(method) do |*args|
      object.send(method, *args)
    end
  end
end
