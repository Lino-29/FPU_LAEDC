module add_sub_asserts(add_sub_main_if add_sub_main_if_inst, add_sub_main add_sub_main_inst);

    initial begin
        forever begin
            #5; // Espera para permitir que los valores se propaguen

            // Verificación de la suma
            assert (add_sub_main_inst.result == (add_sub_main_if_inst.a + add_sub_main_if_inst.b))
                else $error("Error en la suma en tiempo %t: %d + %d != %d", 
                            $time, add_sub_main_if_inst.a, add_sub_main_if_inst.b, add_sub_main_inst.result);
        end
    end
endmodule