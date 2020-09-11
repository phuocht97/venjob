class Admin < ApplicationRecord
  FIRST_DAY = 1
  LAST_DAY = 31

  FIRST_MONTH = 1
  LAST_MONTH = 12

  FIRST_YEAR = 2015
  LAST_YEAR = Time.current.year
end
