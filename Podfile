platform :ios, '10.0'

target 'TrustCore' do
  use_frameworks!
  pod 'BigInt', '~> 3.0'
  pod 'SwiftLint'
  pod 'TrezorCrypto', '~> 0.0.9', inhibit_warnings: true
  pod 'TrustWalletCore', git: 'git@github.com:TrustWallet/trust-wallet-core.git', branch: 'master'
  pod 'SwiftProtobuf', '~> 1.0'
  
  target 'TrustCoreTests'
end
