MoneyRails.configure do |config|
  config.default_currency = :eur
  config.no_cents_if_whole = false
  config.amount_column = { postfix: "_cents" }
  config.locale_backend = :i18n
  I18n.locale = :en
  config.rounding_mode = BigDecimal::ROUND_HALF_UP
end
