use array::ArrayTrait;
use result::ResultTrait;
use protostar_print::PrintTrait;

const NAME: felt252 = 'Stellar';
const SYMBOL: felt252 = 'SNFT';
const THIRD_PARTY_ADDRESS: felt252 = 123;
const THIRD_PARTY_ADDRESS_2: felt252 = 456;
const THIRD_PARTY_ADDRESS_3: felt252 = 789;

fn _deploy_contract() -> felt252 {
    let mut calldata = ArrayTrait::new();
    calldata.append(NAME);
    calldata.append(SYMBOL);
    let contract_address = deploy_contract('stellar', @calldata).unwrap();
    contract_address
}

#[test]
// integration test on deployed contracgt
fn test_get_name_and_symbol() {
    let contract_address = _deploy_contract();

    // call get_name
    let name = call(contract_address, 'get_name', @ArrayTrait::new()).unwrap();
    assert(*name.at(0_u32) == NAME, 'Invalid name');
    name.print();

    // call get_symbol
    let symbol = call(contract_address, 'get_symbol', @ArrayTrait::new()).unwrap();
    assert(*symbol.at(0_u32) == SYMBOL, 'Invalid name');
    symbol.print();
}

#[test]
fn test_balance_of() {
    let contract_address = _deploy_contract();

    let mut calldata = ArrayTrait::new();
    calldata.append(THIRD_PARTY_ADDRESS);
    let balance = call(contract_address, 'balance_of', @calldata).unwrap();
    assert(*balance.at(0_u32) == 0_felt252, 'Invalid balance');
    balance.print();
}

#[test]
fn test_mint() {
    let contract_address = _deploy_contract();

    let mut calldata = ArrayTrait::new();
    calldata.append(THIRD_PARTY_ADDRESS);
    calldata.append(1);
    calldata.append(0);
    invoke(contract_address, 'mint', @calldata);

    let mut calldata = ArrayTrait::new();
    calldata.append(THIRD_PARTY_ADDRESS);
    let balance = call(contract_address, 'balance_of', @calldata).unwrap();
    assert(*balance.at(0_u32) == 1_felt252, 'Invalid balance');
    balance.print();

    // call owner of after mint
    let mut calldata = ArrayTrait::new();
    calldata.append(1);
    calldata.append(0);
    let owner_of = call(contract_address, 'owner_of', @calldata).unwrap();
    assert(*owner_of.at(0_u32) == THIRD_PARTY_ADDRESS, 'Invalid owner');
    owner_of.print();

    // call token_uri after mint
    let mut calldata = ArrayTrait::new();
    calldata.append(1);
    calldata.append(0);
    let token_uri = call(contract_address, 'token_uri', @calldata).unwrap();
    token_uri.print();

    // set_approve_for_all
    // start_prank(THIRD_PARTY_ADDRESS, contract_address).unwrap();
    // let mut calldata = ArrayTrait::new();
    // calldata.append(THIRD_PARTY_ADDRESS_2);
    // let true_data: felt252 = true.into();
    // calldata.append(true_data);
    // invoke(contract_address, 'set_approve_for_all', @calldata).unwrap();
    // call is_approved_for_all

    // approve
    start_prank(THIRD_PARTY_ADDRESS, contract_address).unwrap();
    let mut calldata = ArrayTrait::new();
    calldata.append(THIRD_PARTY_ADDRESS_2);
    calldata.append(1);
    calldata.append(0);
    invoke(contract_address, 'approve', @calldata).unwrap();
    
    // call get_approved
    let mut calldata = ArrayTrait::new();
    calldata.append(1);
    calldata.append(0);
    let is_approved = call(contract_address, 'get_approved', @calldata).unwrap();
    assert(*is_approved.at(0_u32) == THIRD_PARTY_ADDRESS_2, 'Invalid approved');
    is_approved.print();

    // transfer_from
    let mut calldata = ArrayTrait::new();
    calldata.append(THIRD_PARTY_ADDRESS);
    calldata.append(THIRD_PARTY_ADDRESS_3);
    calldata.append(1);
    calldata.append(0);
    invoke(contract_address, 'transfer_from', @calldata).unwrap();

    // call owner of after transfer_from
    let mut calldata = ArrayTrait::new();
    calldata.append(1);
    calldata.append(0);
    let owner_of = call(contract_address, 'owner_of', @calldata).unwrap();
    assert(*owner_of.at(0_u32) == THIRD_PARTY_ADDRESS_3, 'Invalid owner');
    owner_of.print();
}
