#Paolo Frigo, https://www.scriptinglibrary.com

# WIP: PESTER Tests are not completed in this phase.
#      for this reason the following line is commented out.
#. .\monitor-printer.ps1 

describe "DEPENDENCY CHECKS" {
    
    it 'fails if one libary is missing'{
        
    }  
}

describe "FUNCTIONAL CHECKS" {
    it 'creates a log file if does not exists'{
        
    }   
    it 'fails if printername is not found'{
        
    }
    it 'if number of jobs is higher than queue sends out notifications'{
        
    }
}

describe "NOTIFICATIONS CHECKS" {
    it 'if uri cointains slack send out slack notifications'{
        
    }  
    it 'if uri cointains outlook send out teams notifications'{
        
    } 
    it 'if uri is not recognised throws an error'{
        
    }    
}