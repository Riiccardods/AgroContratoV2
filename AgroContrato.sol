// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract AgroContrato {
    struct Contrato {
        string nomeCliente;
        string cpf;
        uint256 dataInicio;
        uint256 dataFim;
        bool ativo;
    }

    mapping(string => Contrato) contratos;

    event ContratoCriado(string cpf, uint256 dataInicio, uint256 dataFim);
    event ContratoRenovado(string cpf, uint256 novaDataFim);

    // 🔐 Cadastra um novo contrato
    function cadastrarAssinatura(
        string memory nome,
        string memory cpf,
        uint256 dataInicio,
        uint256 dataFim
    ) public {
        require(bytes(contratos[cpf].cpf).length == 0, "Contrato ja existe");

        contratos[cpf] = Contrato({
            nomeCliente: nome,
            cpf: cpf,
            dataInicio: dataInicio,
            dataFim: dataFim,
            ativo: true
        });

        emit ContratoCriado(cpf, dataInicio, dataFim);
    }

    // 🔁 Renova contrato existente com dias extras
    function renovarAssinatura(string memory cpf, uint256 diasExtras) public {
        require(contratos[cpf].ativo, "Contrato inativo ou inexistente");
        contratos[cpf].dataFim += diasExtras * 1 days;

        emit ContratoRenovado(cpf, contratos[cpf].dataFim);
    }

    // 📄 Consulta comprovante da assinatura
    function consultarComprovante(string memory cpf)
        public
        view
        returns (string memory nome, uint256 inicio, uint256 fim, bool ativo)
    {
        require(bytes(contratos[cpf].cpf).length > 0, "Contrato nao encontrado");
        Contrato memory c = contratos[cpf];
        return (c.nomeCliente, c.dataInicio, c.dataFim, c.ativo);
    }
}
