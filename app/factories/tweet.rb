require 'faker'
require 'twitter'

FactoryGirl.define do
  factory :tweet do
    screen_name :'Faker::FirstName'
    text 'Black spot spyglass tender sutler Plate Fleet gabion coxswain man-of-war mutiny Barbary Coast Brethren of the Coast doubloon hardtack bilge water fire ship Gold Road square-rigged hempen halter salmagundi cutlass ballast gally Blimey hogshead league list Sea Legs coffer rutters crimp chandler tack ye holystone scourge of the seven seas brigantine nipper stern provost loaded to the gunwalls yard shot chantey to go on account pirate bounty bilge rat grog blossom yardarm.'
  end
end