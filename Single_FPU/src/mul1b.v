module mul1b (si,x,y,ci,so,co);
	//Puertos
	//sentido  tipo   tamaño   nombre 
	input 			   si,x,y,ci;
	output			   so,co;
	//Alambres
	//tipo       tamaño  nombre
	wire			  			x0;
	
	//Registros

//Asignaciones///
	//señales
	assign x0=x&y;
	
	//Componente
	//nombre   etiqueta (puertos)
	sum1b      n0       (.a(si),.b(x0),.ci(ci),.so(so),.co(co));
	
	
	//Secuenciales
endmodule 