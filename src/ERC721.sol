// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {IERC165} from "./library/IERC165.sol";
import {IERC721, IERC721Receiver} from "./library/IERC721.sol";

contract ERC721 is IERC721 {
    error TokenNotExist();
    error ZeroAddress();
    error NoAuthorized();
    error NotOwner();
    error NotOwnerOfTokenId();
    error UnsafeRecipient();
    error TokenAlreadyExist();

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed id
    );
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 indexed id
    );
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    mapping(uint256 => address) internal _ownerOf;
    mapping(address => uint256) internal _balanceOf;
    mapping(uint256 => address) internal _approvals;
    mapping(address => mapping(address => bool)) public isApprovedForAll;
    uint256 public currentTokenId;

    modifier zeroAddress(address account) {
        if (account == address(0)) revert ZeroAddress();
        _;
    }

    modifier notOwnerOfTokenId(address account, uint256 tokenId) {
        if (_ownerOf[tokenId] != account) revert NotOwnerOfTokenId();
        _;
    }

    modifier tokenNotExist(uint256 tokenId) {
        if (_ownerOf[tokenId] == address(0)) revert TokenNotExist();
        _;
    }

    function balanceOf(
        address owner
    ) external view zeroAddress(owner) returns (uint256) {
        return _balanceOf[owner];
    }

    function ownerOf(
        uint256 tokenId
    ) external view tokenNotExist(tokenId) returns (address owner) {
        owner = _ownerOf[tokenId];
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external {
        transferFrom(from, to, tokenId);

        if (
            to.code.length != 0 &&
            IERC721Receiver(to).onERC721Received(
                msg.sender,
                from,
                tokenId,
                ""
            ) ==
            IERC721Receiver.onERC721Received.selector
        ) revert UnsafeRecipient();
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external {
        transferFrom(from, to, tokenId);

        if (
            to.code.length != 0 &&
            IERC721Receiver(to).onERC721Received(
                msg.sender,
                from,
                tokenId,
                ""
            ) ==
            IERC721Receiver.onERC721Received.selector
        ) revert UnsafeRecipient();
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public zeroAddress(to) notOwnerOfTokenId(from, tokenId) {
        _balanceOf[from]--;
        _balanceOf[to]++;
        _ownerOf[tokenId] = to;

        delete _approvals[tokenId];

        emit Transfer(from, to, tokenId);
    }

    function approve(address spender, uint256 tokenId) external {
        address owner = _ownerOf[tokenId];
        if (msg.sender == owner || isApprovedForAll[owner][spender])
            revert NoAuthorized();

        _approvals[tokenId] = spender;

        emit Approval(owner, spender, tokenId);
    }

    function getApproved(
        uint256 tokenId
    ) external view tokenNotExist(tokenId) returns (address) {
        return _approvals[tokenId];
    }

    function setApprovalForAll(address operator, bool approved) external {
        isApprovedForAll[msg.sender][operator] = approved;

        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) external pure returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC165).interfaceId;
    }

    function mint(address to) external zeroAddress(to) {
        uint256 tokenId = ++currentTokenId;
        _balanceOf[to]++;
        _ownerOf[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }

    function burn(uint256 tokenId) external tokenNotExist(tokenId) {
        if (_ownerOf[tokenId] != msg.sender) revert NotOwner();

        _balanceOf[msg.sender]--;

        delete _ownerOf[tokenId];
        delete _approvals[tokenId];

        emit Transfer(msg.sender, address(0), tokenId);
    }

    function _isApprovedOrOwner(
        address owner,
        address spender,
        uint256 tokenId
    ) internal view returns (bool) {
        return (spender == owner ||
            isApprovedForAll[owner][spender] ||
            spender == _approvals[tokenId]);
    }
}
