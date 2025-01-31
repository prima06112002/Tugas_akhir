// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PembayaranKRS {
    struct Pembayaran {
        string namaMahasiswa;
        string nim;
        uint256 jumlah;
        bool lunas;
    }

    mapping(string => Pembayaran) public pembayaranMahasiswa;
    address public admin;
    
    event PembayaranBerhasil(string indexed nim, uint256 jumlah);
    event StatusLunas(string indexed nim, bool lunas);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Hanya admin yang dapat melakukan ini");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function bayarKRS(string memory _nama, string memory _nim) public payable {
        require(msg.value > 0, "Jumlah pembayaran harus lebih dari 0");
        require(bytes(_nim).length > 0, "NIM harus diisi");
        
        pembayaranMahasiswa[_nim] = Pembayaran({
            namaMahasiswa: _nama,
            nim: _nim,
            jumlah: msg.value,
            lunas: true
        });

        emit PembayaranBerhasil(_nim, msg.value);
    }

    function cekStatusPembayaran(string memory _nim) public view returns (bool) {
        return pembayaranMahasiswa[_nim].lunas;
    }

    function tarikDana() public onlyAdmin {
        payable(admin).transfer(address(this).balance);
    }
    
    receive() external payable {}
}
