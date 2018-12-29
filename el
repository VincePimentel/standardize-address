
[1mFrom:[0m /home/VincePimentel/temporary/standardize-address/lib/standardize_address/cli.rb @ line 120 StandardizeAddress::CLI#verify_error_check:

    [1;34m119[0m: [32mdef[0m [1;34mverify_error_check[0m(address_hash)
 => [1;34m120[0m:   binding.pry
    [1;34m121[0m:   address = [1;34;4mStandardizeAddress[0m::[1;34;4mVerify[0m.new(address_hash)
    [1;34m122[0m: 
    [1;34m123[0m:   [32mif[0m address.any_error?
    [1;34m124[0m:     menu_options = [[31m[1;31m"[0m[31mY[1;31m"[0m[31m[0m, [31m[1;31m"[0m[31m[1;31m"[0m[31m[0m, [31m[1;31m"[0m[31mN[1;31m"[0m[31m[0m]
    [1;34m125[0m:     user_option = [31m[1;31m"[0m[31m![1;31m"[0m[31m[0m
    [1;34m126[0m:     [32muntil[0m valid_option?(user_option, menu_options)
    [1;34m127[0m:       banner([31m[1;31m"[0m[31mADDRESS STANDARDIZATION[1;31m"[0m[31m[0m)
    [1;34m128[0m:       address.display
    [1;34m129[0m:       spacer
    [1;34m130[0m:       puts [31m[1;31m"[0m[31mDo you want to try again? (y/n)[1;31m"[0m[31m[0m
    [1;34m131[0m:       spacer
    [1;34m132[0m:       user_option = gets.strip.upcase
    [1;34m133[0m:     [32mend[0m
    [1;34m134[0m:     spacer
    [1;34m135[0m: 
    [1;34m136[0m:     [32mcase[0m user_option
    [1;34m137[0m:     [32mwhen[0m [31m[1;31m"[0m[31mY[1;31m"[0m[31m[0m, [31m[1;31m"[0m[31m[1;31m"[0m[31m[0m
    [1;34m138[0m:       verify
    [1;34m139[0m:     [32mwhen[0m [31m[1;31m"[0m[31mN[1;31m"[0m[31m[0m
    [1;34m140[0m:       menu
    [1;34m141[0m:     [32mend[0m
    [1;34m142[0m:   [32melse[0m
    [1;34m143[0m:     verify_save?(address)
    [1;34m144[0m:   [32mend[0m
    [1;34m145[0m: [32mend[0m

