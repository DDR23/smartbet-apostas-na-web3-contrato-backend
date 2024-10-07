# SmartbetDisputes - Contrato Inteligente de Apostas Descentralizadas

## Sobre o Projeto
Este projeto implementa um sistema de apostas descentralizado usando um contrato inteligente em Solidity. Ele permite que os usuários criem e participem de disputas (eventos de apostas) na blockchain Ethereum.

contrato hospedado na rede: amoy testnet
endereço do contrato: 0x0901850241990199019901990199019901990199
github do dapp: https://github.com/matheus-mello/smartbet-disputes


## Funcionalidades
- Criar disputas com dois candidatos
- Fazer apostas em candidatos
- Cálculo e coleta automática de taxas
- Distribuição justa de prêmios baseada nos valores das apostas
- Reivindicação de prêmios após a resolução da disputa

## Detalhes do Contrato Inteligente

### Componentes Principais
1. **Disputa**: Representa um evento de aposta com dois candidatos.
2. **Aposta**: Representa a aposta de um usuário em uma disputa específica.

### Funções Principais
- `createDispute`: Permite ao proprietário criar uma nova disputa.
- `createBet`: Permite aos usuários fazerem apostas em uma disputa.
- `finishDispute`: Permite ao proprietário resolver uma disputa declarando um vencedor.
- `claimPrize`: Permite aos vencedores reivindicarem seus prêmios.

### Estrutura de Taxas
- Uma taxa de 10% é deduzida de cada aposta.
- As taxas são coletadas pelo proprietário do contrato, no fechamento da disputa.

### Cálculo de Prêmios
- O contrato calcula o prêmio individual baseado na aposta e na aposta do candidato vencedor.

## Como Começar

### Pré-requisitos
- Solidity ^0.8.26
- Ambiente de desenvolvimento Ethereum (ex: Truffle, Hardhat)
- Carteira Ethereum (ex: MetaMask)

### Implantação
1. Implante o contrato `SmartbetDisputes` na rede Ethereum de sua escolha.
2. O endereço que faz a implantação se torna o proprietário do contrato.

### Interagindo com o Contrato
- Use um frontend habilitado para web3 ou interaja diretamente através de interfaces de carteira Ethereum.

## Considerações de Segurança
- O contrato inclui controle de acesso para funções exclusivas do proprietário.

## Aviso Legal
Este contrato inteligente é fornecido como está e foi desencolvido apenas pra fins educacionais. Os usuários interagem com ele por sua própria conta e risco. Sempre realize a devida diligência antes de participar de qualquer sistema de apostas baseado em blockchain.
