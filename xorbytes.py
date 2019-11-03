def xorbytes(alpha,bravo=b'\x00'*16):
  output = b''
  for b in range(len(alpha)):
    output += bytes([ alpha[b] ^ bravo[b%len(bravo)] ])
  return output

