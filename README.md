# APB-protocol-using-UVM
In this project, created a Slave DUT and driver component acts like a master. Master first sets psel line high and sends paddr and pwrite bit ( 1 for write and 0 for read) in the setup cycle. If it is write then sends pwdata in the setup cycle. In the enable cycle it sets penable and pready lines high . When penable line and pwrite lines are high, slave captures the pwdata and stores it in its internal register. When penable line is high and pwrite line is low, slave sends prdata to master. Monitor captures the transmission on the interface at some intervals and sends them to scoreboard where expected and actual data are compared.
