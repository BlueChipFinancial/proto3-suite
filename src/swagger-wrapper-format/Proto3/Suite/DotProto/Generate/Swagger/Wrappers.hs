{-# LANGUAGE CPP #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

{-# OPTIONS_GHC -Wno-orphans #-}

module Proto3.Suite.DotProto.Generate.Swagger.Wrappers where

#if MIN_VERSION_swagger2(2,4,0)
import Control.Lens ((?~))
#else
import Control.Lens ((.~))
#endif
import Data.Functor ((<&>))
import Data.Int (Int32, Int64)
import Data.Proxy (Proxy (..))
import Data.Swagger
  ( Definitions
  , NamedSchema (..)
  , Schema
  , ToSchema (..)
  , byteSchema
  , format
  , paramSchema
  , schema
  )
import Data.Swagger.Declare (Declare)
import Data.Word (Word32, Word64)
import Proto3.Suite.DotProto.Generate.Swagger.OverrideToSchema (OverrideToSchema(..))

import qualified Data.ByteString as B
import qualified Data.ByteString.Lazy as BL
import qualified Data.Text as T
import qualified Data.Text.Lazy as TL

-- | Wrapped Type Schemas

setFormat
  :: T.Text
  -> Declare (Definitions Schema) NamedSchema
  -> Declare (Definitions Schema) NamedSchema
setFormat formatValue namedSchema =
  namedSchema
#if MIN_VERSION_swagger2(2,4,0)
    <&> schema . paramSchema . format ?~ formatValue
#else
    <&> schema . paramSchema . format .~ formatValue
#endif

declareWrapperNamedSchema
  :: forall a
   . ToSchema a
  => T.Text
  -> Proxy (OverrideToSchema a)
  -> Declare (Definitions Schema) NamedSchema
declareWrapperNamedSchema formatValue _ =
  setFormat formatValue (declareNamedSchema (Proxy :: Proxy a))

instance {-# OVERLAPPING #-} ToSchema (OverrideToSchema (Maybe Double)) where
  declareNamedSchema = declareWrapperNamedSchema "DoubleValue"

instance {-# OVERLAPPING #-} ToSchema (OverrideToSchema (Maybe Float)) where
  declareNamedSchema = declareWrapperNamedSchema "FloatValue"

instance {-# OVERLAPPING #-} ToSchema (OverrideToSchema (Maybe Int64)) where
  declareNamedSchema = declareWrapperNamedSchema "Int64Value"

instance {-# OVERLAPPING #-} ToSchema (OverrideToSchema (Maybe Word64)) where
  declareNamedSchema = declareWrapperNamedSchema "UInt64Value"

instance {-# OVERLAPPING #-} ToSchema (OverrideToSchema (Maybe Int32)) where
  declareNamedSchema = declareWrapperNamedSchema "Int32Value"

instance {-# OVERLAPPING #-} ToSchema (OverrideToSchema (Maybe Word32)) where
  declareNamedSchema = declareWrapperNamedSchema "UInt32Value"

instance {-# OVERLAPPING #-} ToSchema (OverrideToSchema (Maybe Bool)) where
  declareNamedSchema = declareWrapperNamedSchema "BoolValue"

instance {-# OVERLAPPING #-} ToSchema (OverrideToSchema (Maybe T.Text)) where
  declareNamedSchema = declareWrapperNamedSchema "StringValue"

instance {-# OVERLAPPING #-} ToSchema (OverrideToSchema (Maybe TL.Text)) where
  declareNamedSchema = declareWrapperNamedSchema "StringValue"

instance {-# OVERLAPPING #-} ToSchema (OverrideToSchema (Maybe B.ByteString)) where
  declareNamedSchema _ =
    setFormat "BytesValue" (pure (NamedSchema Nothing byteSchema))

instance {-# OVERLAPPING #-} ToSchema (OverrideToSchema (Maybe BL.ByteString)) where
  declareNamedSchema _ =
    setFormat "BytesValue" (pure (NamedSchema Nothing byteSchema))
