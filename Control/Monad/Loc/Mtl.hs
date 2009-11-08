{-# LANGUAGE OverlappingInstances #-}
module Control.Monad.Loc.Mtl where

import Control.Monad.Loc

import Control.Monad.Error
import Control.Monad.List
import Control.Monad.Reader
import Control.Monad.State.Lazy     as Lazy
import Control.Monad.State.Strict   as Strict
import Control.Monad.Writer.Lazy    as Lazy
import Control.Monad.Writer.Strict  as Strict
import Control.Monad.RWS.Lazy       as Lazy
import Control.Monad.RWS.Strict     as Strict
import Data.Monoid

instance MonadLoc m => MonadLoc (ListT m) where
  withLoc l = ListT . withLoc l . runListT

instance (Error e, MonadLoc m) => MonadLoc (ErrorT e m) where
  withLoc l = ErrorT . withLoc l . runErrorT

instance MonadLoc m => MonadLoc (ReaderT r m) where
  withLoc l m = ReaderT $ \r -> withLoc l $ runReaderT m r

instance (Monoid w, MonadLoc m) => MonadLoc (Lazy.WriterT w  m) where
  withLoc l = Lazy.WriterT . withLoc l . Lazy.runWriterT

instance MonadLoc m => MonadLoc (Lazy.StateT s m) where
  withLoc l m = Lazy.StateT $ \s -> withLoc l $ Lazy.runStateT m s

instance (Monoid w, MonadLoc m) => MonadLoc (Lazy.RWST r w s m) where
  withLoc l m = Lazy.RWST $ \r s -> withLoc l $ Lazy.runRWST m r s

instance (Monoid w, MonadLoc m) => MonadLoc (Strict.WriterT w  m) where
  withLoc l = Strict.WriterT . withLoc l . Strict.runWriterT

instance MonadLoc m => MonadLoc (Strict.StateT s m) where
  withLoc l m = Strict.StateT $ \s -> withLoc l $ Strict.runStateT m s

instance (Monoid w, MonadLoc m) => MonadLoc (Strict.RWST r w s m) where
  withLoc l m = Strict.RWST $ \r s -> withLoc l $ Strict.runRWST m r s
