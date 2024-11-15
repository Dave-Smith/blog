+++
date = '2024-11-05T17:32:39-06:00'
draft = true
title = 'Certainly'
+++

JavaScript Developers in corporate Windows environments are constantly stopped with the dreaded SSL Error:

> Error: "Error: SSL Error: SELF_SIGNED_CERT_IN_CHAIN"


#### Why does this Happen?

Most corporate Windows environments inspect internet traffic using a self signed SSL certificate to decrypt traffic, inspect it, encrypt is again on its way back to you. Node sees this happening and throws an error (rightfully so) thinking there is a milcious man-in-the-middle attack.


