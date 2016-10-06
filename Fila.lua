
local json = require("dkjson")


local listaAdd = {}
local listaRm = {}

sair = true

fileNameAdd = "listaAdd.json"
fileNameRm = "listaRm.json"

function fileIfExist(fileName)
	local f = io.open(fileName, "rb")
	if f then 
		f:close()
	end
	return f ~= nil
end

function readFile(fileName)
	if fileIfExist(fileName) then
		local file = io.open(fileName, "rb")
		local content = file:read()
		file:close()
		return content
	end
end

function gravar()
	strListaAdd = json.encode(listaAdd);
	strListaRm = json.encode(listaRm);

	local fileListaAdd = io.open(fileNameAdd, "w")
	local fileListaRm = io.open(fileNameRm, "w")

	if fileIfExist(fileNameAdd) then
		if fileIfExist(fileNameRm) then
			-- Save File
			io.output(fileListaAdd)
			io.write(strListaAdd)
			io.close(fileListaAdd)

			io.output(fileListaRm)
			io.write(strListaRm)
			io.close(fileListaRm)
		end
	end

end

function isempty(s)
	return s == nil or s == ""
end

function retList()
	-- Carregar file
	listaAddStr = readFile("listaAdd.json")
	listaRmStr = readFile("listaRm.json")

	if not isempty(listaAddStr) or not isempty(listaRmStr) then
		objAdd, posAdd, errAdd = json.decode(listaAddStr, 1, nil)
		objRm, posRm, errRm = json.decode(listaRmStr, 1, nil)
	end

	if errAdd then
		print("Error", errAdd)
	else
		-- Teste
		listaAdd = objAdd
	end

	if errRm then
		print("Error", errRm)
	else
		listaRm = objRm
	end
end

print("Olá esse é um programa de cadastro,\nNele você tem a possibilidade "
		.. "de cadastrar quantos usuarios você quiser, para sua lsta,"
		.. "\n\nEscolha a opção ideal para seu problema\n")

while sair do

	retList()

	print("\n1 - Cadastrar algum cliente")
	print("2 - Buscar algum cliente via CPF")
	print("3 - Listar todos os clientes")
	print("4 - Listar todos os clientes removidos")
	print("5 - Excluir algum cliente")
	print("6 - Sair daqui")
	
	escolha = tonumber(io.read())
	
	if escolha == 6 then
		sair = false
		print("Thau!")

	elseif escolha == 1 then
		os.execute("clear")

		print("Qual seu nome?")
		local nome = io.read()
		print("Seu CPF")
		local cpf = io.read()

		cliente = {}
		cliente.cpf = cpf
		cliente.nome = nome

		table.insert(listaAdd, cliente)

		gravar()

	elseif escolha == 2 then

		os.execute("clear")
		print("Digite o CPF")
		local cpf = io.read()

		for key, value in pairs(listaAdd) do
			if value.cpf == cpf then
				print("O cliente " .. value.nome .. " foi achado presente no CPF " .. value.cpf)
			end
		end

		io.read()

	elseif escolha == 3 then

		os.execute("clear")

		print("Clientes cadastrados")

		for key, value in pairs(listaAdd) do
			print(key, value.nome .. ": " .. value.cpf)
		end

	elseif escolha == 4 then
		os.execute("clear")

		for key, value in pairs(listaRm) do
			print("Clientes excluidos\n")
			print(key, value.nome .. ": " .. value.cpf)
		end

	elseif escolha == 5 then
		os.execute("clear")

		print("Informe o CPF a ser excluido")
		local cpf = io.read()
		local keyAchado = -1
		local clienteAchado = {}

		for key, value in pairs(listaAdd) do
			if value.cpf == cpf then
				keyAchado = key
				clienteAchado = value
			end
		end

		if keyAchado == -1 then
			print("Cliente não achado")
		else
			print("Você tem certesa que deseja excluir esse cliente? (s/n)")
			decisao = io.read()
			if decisao == "s" then
				table.remove(listaAdd, keyAchado)
				table.insert(listaRm, clienteAchado)
				gravar()
				print("Cliente excluido com sucesso")
			end
		end
	end
end
