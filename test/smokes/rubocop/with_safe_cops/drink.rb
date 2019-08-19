class Drink
  def tea; end

  def coffee; end

  def double_ristretto_venti_half_soy_nonfat_decaf_organic_chocolate_brownie_iced_vanilla_double_shot_gingerbread_frappuccino_extra_hot_with_foam_whipped_cream_upside_down_double_blended_one_sweetn_low_and_one_nutrasweet_and_ice; end

  def is_green_tea?; end

  def serve(user)
    order(user)
  ensure
  end

  private

  def order(customer)
    customer&.orders.drinks
  end
end
