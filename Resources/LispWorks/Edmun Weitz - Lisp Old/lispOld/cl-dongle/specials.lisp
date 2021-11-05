;;; -*- Mode: LISP; Syntax: COMMON-LISP; Package: CL-DONGLE; Base: 10 -*-
;;; $Header: /usr/local/cvsrep/cl-dongle/specials.lisp,v 1.13 2008/04/17 22:31:10 edi Exp $

;;; Copyright (c) 2008, Dr. Edmund Weitz. All rights reserved.

;;; Redistribution and use in source and binary forms, with or without
;;; modification, are permitted provided that the following conditions
;;; are met:

;;; * Redistributions of source code must retain the above copyright
;;; notice, this list of conditions and the following disclaimer.

;;; * Redistributions in binary form must reproduce the above
;;; copyright notice, this list of conditions and the following
;;; disclaimer in the documentation and/or other materials
;;; provided with the distribution.

;;; THIS SOFTWARE IS PROVIDED BY THE AUTHOR 'AS IS' AND ANY EXPRESSED
;;; OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
;;; WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;;; ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
;;; DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
;;; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
;;; GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
;;; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
;;; WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
;;; NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
;;; SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

(in-package :cl-dongle)

(defmacro define-sgl-constant (name value &optional docstring)
  "Utility macro to make some constants from SglW32.h accessible in
Lisp.  A simple documentation string based on NAME is automatically
created if none was provided."
  (flet ((make-sgl-name (name)
           "Assumes that the Lisp name is always generated by adding
plus signs at both ends and replacing underlines with hyphens."
           (substitute #\_ #\- (string-trim '(#\+) name) :test 'char=)))
  `(defconstant ,name ,value
     ,(or docstring
          (format nil "A Lisp constant corresponding to the C constant ~A.
See the file SglW32.h."
                  (make-sgl-name name)))))     )

;; help the LispWorks IDE to find these definitions
(define-form-parser define-sgl-constant (name)
  `(,define-sgl-constant ,name))

(define-dspec-alias define-sgl-constant (name)
  `(defconstant ,name))

;; setup correct indentation of DEFINE-SGL-CONSTANT
(editor:setup-indent "define-sgl-constant" 2 2 4)

(define-sgl-constant +sgl-dgl-not-found+ #x0001)
(define-sgl-constant +sgl-lpt-busy+ #x0002)
(define-sgl-constant +sgl-lpt-open-error+ #x0003)
(define-sgl-constant +sgl-no-lpt-port-found+ #x0004)
(define-sgl-constant +sgl-authentication-required+ #x0005)
(define-sgl-constant +sgl-authentication-failed+ #x0006)
(define-sgl-constant +sgl-function-not-supported+ #x0007)
(define-sgl-constant +sgl-parameter-invalid+ #x0008)
(define-sgl-constant +sgl-signature-invalid+ #x0009)
(define-sgl-constant +sgl-usb-busy+ #x000a)

(define-sgl-constant +sgl-read-config-lock-info+ #x0000)

(define-sgl-constant +sgl-config-lock-series-2+ #x0001)
(define-sgl-constant +sgl-config-lock-series-3+ #x0002)
(define-sgl-constant +sgl-config-lock-series-4+ #x0003)

(define-sgl-constant +sgl-config-interface-usb+ #x0000)
(define-sgl-constant +sgl-config-interface-lpt+ #x0001)

(define-sgl-constant +sgl-signature-generate+ 0)
(define-sgl-constant +sgl-signature-verify+ 1)

(define-sgl-constant +sgl-sign-data-initvector-1+ #xc4f8424e)
(define-sgl-constant +sgl-sign-data-initvector-2+ #xab99a60c)
(define-sgl-constant +sgl-sign-data-fillupdata+ #xf6a67a11)

(define-sgl-constant +sgl-crypt-mode-encrypt+ 0)
(define-sgl-constant +sgl-crypt-mode-decrypt+ 1)

(defvar *demo-authentication-code*
  '(#xf574d17b
    #xa94628ee
    #xf2857a8f
    #x69346b4a
    #x4136e8f2
    #x89adc688
    #x80c2c1d4
    #xa8c6327c
    #x1a72699a
    #x574b7ca0
    #x1e8d3e98
    #xd7defdc5)
  "The authentication code for demo dongles distributed by SG-Lock.")

(defconstant +tea-delta+
  (integer-to-int32 (cast-integer #x9E3779B9 '(:signed :long)))
  "Constant used in the Tiny Encryption Algorithm.")

(defconstant +tea-sum+
  (integer-to-int32 (cast-integer #xC6EF3720 '(:signed :long)))
  "Constant used in the Tiny Encryption Algorithm.")

(defvar *product-id* 1
  "The default value for all functions which have an optional or
keyword PRODUCT-ID parameter.")

(defconstant +max-interval+ (- (integer-length most-positive-fixnum) 4)
  "The greatest N for which 2^\(N+3) is still a fixnum.")