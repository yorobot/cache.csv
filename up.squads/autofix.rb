

## autofix known errors in player records
def autofix( rec )

  ## fix for  Mike Penders (BEL)
  if rec['Name'] == 'Mike Penders' && rec['Nat'] == 'BEL'
    ## "Date of Birth"=>"31-06-05",
    rec['Date of Birth'] = '31-07-05'  #  is July (not June) - June 31st does NOT exist!!  
  end

 if rec['Name'] == 'Luca Philipp' && rec['Nat'] == 'GET'
    rec['Nat'] = 'GER'
 end
 
end