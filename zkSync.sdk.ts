import { Provider, types, Wallet, utils } from 'zksync-ethers';
import { ethers } from 'ethers';
import dotenv from 'dotenv';
dotenv.config();

const PRIVATE_KEY = process.env.WALLET_PRIVATE_KEY || '';
const l2Provider = Provider.getDefaultProvider(types.Network.Sepolia);
const wallet = new Wallet(PRIVATE_KEY, l2Provider);
const ADDRESS = '0xFAf24a28349836f4B0fc16fDC08AC25A50322FA6';
const RECEIVER = '0xaE7fc78662332Ec3936135036f17404176edca1f';
const tokenAddress = '0xbaB1e66465B59DE504F52b64C2F6A2ebbe0eFC99';
const paymasterAddress = '0xcFcfEdB882f95a3CF843CD8Ddb1B826cd21d3cB1';


const paymasterParams = utils.getPaymasterParams(paymasterAddress, {
  type: 'ApprovalBased',
  token: tokenAddress,
  minimalAllowance: 1,
  innerInput: new Uint8Array()
});

// Token Approve Using EIP-712 gas estimate 
// gas estimate: 420158 

// (async () => {
//   const tokenApprove = await l2Provider.estimateGas({
//     from: ADDRESS,
//     to: tokenAddress,
//     data: utils.IERC20.encodeFunctionData("approve", [RECEIVER, 1]),
//     customData: {
//       gasPerPubdata: utils.DEFAULT_GAS_PER_PUBDATA_LIMIT,
//       paymasterParams
//     }
//   })
//   console.log(`Gas for token approval using EIP-712 tx: ${tokenApprove}`);
// })();

// Token Approve gas estimate 
// gas estimate: 254142
  (async () => {
     const gasTokenApprove = await l2Provider.estimateGas({
    from: '0xFAf24a28349836f4B0fc16fDC08AC25A50322FA6',
    to: '0xaE7fc78662332Ec3936135036f17404176edca1f',
    data: utils.IERC20.encodeFunctionData("approve", [RECEIVER, 1])
  });
  console.log(`Gas for token approval tx: ${gasTokenApprove}`);
  })();