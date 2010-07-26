#include <ruby.h>
#include <cstdio>               // for debug
#include <cstring>
#include "token.h"
#include "dict.h"
#include "algor.h"
#include "word.h"
#include "cixing.h"

using namespace std;

extern "C" {

    /*****************************************
     * 
     * Normal interface
     *
     *****************************************/

    /*********************
     * RMMSeg module
     *********************/
    static VALUE mRMMSeg;


    /*********************
     * Dictionary module
     *********************/
    static VALUE mDictionary;

    /*
     * Load a character dictionary.
     *
     * call-seq:
     *   load_chars(path)    -> status
     *
     * Return +true+ if loaded successfully, +false+ otherwise.
     */ 
    static VALUE dic_load_chars(VALUE mod, VALUE path)
    {
        if (rmmseg::dict::load_chars(RSTRING(path)->ptr))
            return Qtrue;
        return Qfalse;
    }

    /*
     * Load a word dictionary.
     *
     * call-seq:
     *   load_words(path)    -> status
     *
     * Return +true+ if loaded successfully, +false+ otherwise.
     */ 
    static VALUE dic_load_words(VALUE mod, VALUE path)
    {
        if (rmmseg::dict::load_words(RSTRING(path)->ptr))
            return Qtrue;
        return Qfalse;
    }

		static VALUE dic_mem_usage(VALUE self)
		{
			printf("mem_usage: %d\n", dict_mem);
		}

    /*
     * Add a word to the in-memory dictionary.
     *
     * call-seq:
     *   add(word, length, freq)
     *
     * - +word+ is a String.
     * - +length+ is number of characters (not number of bytes) of the
     *   word to be added.
     * - +freq+ is the frequency of the word. This is only used when
     *   it is a one-character word.
     */ 
    static VALUE dic_add(VALUE mod, VALUE word, VALUE len, VALUE freq, VALUE cixing)
    {
        const char *str = RSTRING(word)->ptr;
        int nbytes = RSTRING(word)->len;
				char *cx = RSTRING(cixing)->ptr;
        rmmseg::Word *w = rmmseg::make_word(str, FIX2INT(len), FIX2INT(freq), cx, nbytes);
        rmmseg::dict::add(w);
        return Qnil;
    }

    /*
     * Check whether one word is included in the dictionary.
     *
     * call-seq:
     *   has_word?(word)    -> result
     *
     * Return +true+ if the word is included in the dictionary,
     * +false+ otherwise.
     */ 
    static VALUE dic_has_word(VALUE mod, VALUE word)
    {
        const char *str = RSTRING(word)->ptr;
        int nbytes = RSTRING(word)->len;
        if (rmmseg::dict::get(str, nbytes) != NULL)
            return Qtrue;
        return Qfalse;
    }


    /**********************
     * Token Class
     **********************/
    struct Token
    {
		    VALUE text;
        VALUE start;
        VALUE end;
				VALUE freq;
				VALUE cixing;
		};

    static void tk_mark(Token *t)
    {
        // start and end are Fixnums, no need to mark
        rb_gc_mark(t->text);
		}
    static void tk_free(Token *t)
    {
        free(t);
    }

    /*
     * Get the text held by this token.
     *
     * call-seq:
     *   text()    -> text
     *   
     */
    static VALUE tk_text(VALUE self)
    {
        Token *tk = (Token *)DATA_PTR(self);
        return tk->text;
    }

		static VALUE tk_cixing(VALUE self)
		{
			Token *tk = (Token *)DATA_PTR(self);
			return tk->cixing;
		}

		static VALUE tk_freq(VALUE self)
		{
			Token *tk = (Token *)DATA_PTR(self);
			return tk->freq;
		}

		/*
		 * 下面17个函数都差不多就是告诉你是不是某种词性
		 */
		static VALUE tk_cx_unkown(VALUE self)
		{
			Token *tk = (Token *)DATA_PTR(self);
			int cixing = FIX2INT(tk->cixing);
			if(CX_UNKNOWN(cixing)){
				return Qtrue;
			}else{
				return Qfalse;
			}
		}

		static VALUE tk_cx_noun(VALUE self)
		{
			Token *tk = (Token *)DATA_PTR(self);
			int cixing = FIX2INT(tk->cixing);
			if(CX_NOUN(cixing)){
				return Qtrue;
			}else{
				return Qfalse;
			}
		}

		static VALUE tk_cx_verb(VALUE self)
		{
			Token *tk = (Token *)DATA_PTR(self);
			int cixing = FIX2INT(tk->cixing);
			if(CX_VERB(cixing)){
				return Qtrue;
			}else{
				return Qfalse;
			}
		}

    static VALUE tk_cx_adj(VALUE self)
    {
      Token *tk = (Token *)DATA_PTR(self);
      int cixing = FIX2INT(tk->cixing);
      if(CX_ADJ(cixing)){
        return Qtrue;
      }else{
        return Qfalse;
      }
    }

    static VALUE tk_cx_adv(VALUE self)
    {
      Token *tk = (Token *)DATA_PTR(self);
      int cixing = FIX2INT(tk->cixing);
      if(CX_ADV(cixing)){
        return Qtrue;
      }else{
        return Qfalse;
      }
    }

    static VALUE tk_cx_clas(VALUE self)
    {
      Token *tk = (Token *)DATA_PTR(self);
      int cixing = FIX2INT(tk->cixing);
      if(CX_CLAS(cixing)){
        return Qtrue;
      }else{
        return Qfalse;
      } 
    }

    static VALUE tk_cx_echo(VALUE self)
    {
      Token *tk = (Token *)DATA_PTR(self);
      int cixing = FIX2INT(tk->cixing);
      if(CX_ECHO(cixing)){
        return Qtrue;
      }else{
        return Qfalse;
      }
    }

    static VALUE tk_cx_stru(VALUE self)
    {
      Token *tk = (Token *)DATA_PTR(self);
      int cixing = FIX2INT(tk->cixing);
      if(CX_STRU(cixing)){
        return Qtrue;
      }else{
        return Qfalse;
      }
    }

    static VALUE tk_cx_aux(VALUE self)
    {
      Token *tk = (Token *)DATA_PTR(self);
      int cixing = FIX2INT(tk->cixing);
      if(CX_AUX(cixing)){
        return Qtrue;
      }else{
        return Qfalse;
      }
    }

    static VALUE tk_cx_coor(VALUE self)
    {
      Token *tk = (Token *)DATA_PTR(self);
      int cixing = FIX2INT(tk->cixing);
      if(CX_COOR(cixing)){
        return Qtrue;
      }else{
        return Qfalse;
      }
    }

    static VALUE tk_cx_conj(VALUE self)
    {
      Token *tk = (Token *)DATA_PTR(self);
      int cixing = FIX2INT(tk->cixing);
      if(CX_CONJ(cixing)){
        return Qtrue;
      }else{
        return Qfalse;
      }
    }

    static VALUE tk_cx_suffix(VALUE self)
    {
      Token *tk = (Token *)DATA_PTR(self);
      int cixing = FIX2INT(tk->cixing);
      if(CX_SUFFIX(cixing)){
        return Qtrue;
      }else{
        return Qfalse;
      }
    }

    static VALUE tk_cx_prefix(VALUE self)
    {
      Token *tk = (Token *)DATA_PTR(self);
      int cixing = FIX2INT(tk->cixing);
      if(CX_PREFIX(cixing)){
        return Qtrue;
      }else{
        return Qfalse;
      }
    }

    static VALUE tk_cx_prep(VALUE self)
    {
      Token *tk = (Token *)DATA_PTR(self);
      int cixing = FIX2INT(tk->cixing);
      if(CX_PREP(cixing)){
        return Qtrue;
      }else{
        return Qfalse;
      }
    }

    static VALUE tk_cx_ques(VALUE self)
    {
      Token *tk = (Token *)DATA_PTR(self);
      int cixing = FIX2INT(tk->cixing);
      if(CX_QUES(cixing)){
        return Qtrue;
      }else{
        return Qfalse;
      }
    }

    static VALUE tk_cx_num(VALUE self)
    {
      Token *tk = (Token *)DATA_PTR(self);
      int cixing = FIX2INT(tk->cixing);
      if(CX_NUM(cixing)){
        return Qtrue;
      }else{
        return Qfalse;
      }
    }

    static VALUE tk_cx_idiom(VALUE self)
    {
      Token *tk = (Token *)DATA_PTR(self);
      int cixing = FIX2INT(tk->cixing);
      if(CX_IDIOM(cixing)){
        return Qtrue;
      }else{
        return Qfalse;
      }
    }

		static VALUE tk_cx_game(VALUE self)
		{
			Token *tk = (Token *)DATA_PTR(self);
			int cixing = FIX2INT(tk->cixing);
			if(CX_GAME(cixing)){
				return Qtrue;
			}else{
				return Qfalse;
			}
		}

    /*
     * Get the start position of this token.
     *
     * call-seq:
     *   start()    -> start_pos
     *
     */
    static VALUE tk_start(VALUE self)
    {
        Token *tk = (Token *)DATA_PTR(self);
        return tk->start;
    }

    /*
     * Get the end position of this token.
     *
     * call-seq:
     *   end()    -> end_pos
     *
     */
    static VALUE tk_end(VALUE self)
    {
        Token *tk = (Token *)DATA_PTR(self);
        return tk->end;
    }

    static VALUE cToken;
    static VALUE tk_create(const char* base, const rmmseg::Token &t)
    {
        Token *tk = ALLOC(Token);
        int start = t.text-base;

        // This is necessary, see
        // http://pluskid.lifegoo.com/?p=348
        VALUE text = rb_str_new(t.text, t.length);
        tk->text = text;
        tk->cixing = INT2FIX(t.cixing);
				tk->freq = INT2FIX(t.freq);
        tk->start = INT2FIX(start);
        tk->end = INT2FIX(start + t.length);
        return Data_Wrap_Struct(cToken,
                                (RUBY_DATA_FUNC)tk_mark,
                                (RUBY_DATA_FUNC)tk_free,
                                tk);
    }

    /*********************
     * Algorithm Class
     *********************/
    struct Algorithm
    {
        VALUE text;             // hold to avoid being garbage collected
        rmmseg::Algorithm *algor;
    };

    static void algor_mark(Algorithm *a)
    {
        rb_gc_mark(a->text);
    }
    static void algor_free(Algorithm *a)
    {
        free(a->algor);
    }

    static VALUE cAlgorithm;

    /*
     * Create an Algorithm object to do segmenting on +text+.
     *
     * call-seq:
     *   new(text)    -> algorithm
     *   
     */ 
    static VALUE algor_create(VALUE klass, VALUE text)
    {
        Algorithm *algor = ALLOC(Algorithm);
        void *mem;
        algor->text = text;
        mem = malloc(sizeof(rmmseg::Algorithm));
        algor->algor = new(mem) rmmseg::Algorithm(RSTRING(text)->ptr,
                                                  RSTRING(text)->len);

        return Data_Wrap_Struct(klass,
                                (RUBY_DATA_FUNC)algor_mark,
                                (RUBY_DATA_FUNC)algor_free,
                                algor);
    }

    /*
     * Get next token.
     *
     * call-seq:
     *   next_token()   -> token
     *
     * Return +nil+ if no more token available.
     */ 
    static VALUE algor_next_token(VALUE self)
    {
        Algorithm *algor = (Algorithm *)DATA_PTR(self);
        rmmseg::Token tk = algor->algor->next_token();
        if (tk.length == 0)
            return Qnil;
        return tk_create(RSTRING(algor->text)->ptr, tk);
    }


    void Init_rmmseg()
    {
        mRMMSeg = rb_define_module("RMMSeg");

        /* Manage dictionaries used by rmmseg. */
        mDictionary = rb_define_module_under(mRMMSeg, "Dictionary");
        rb_define_singleton_method(mDictionary, "load_chars", RUBY_METHOD_FUNC(dic_load_chars), 1);
        rb_define_singleton_method(mDictionary, "load_words", RUBY_METHOD_FUNC(dic_load_words), 1);
        rb_define_singleton_method(mDictionary, "add", RUBY_METHOD_FUNC(dic_add), 3);
        rb_define_singleton_method(mDictionary, "has_word?", RUBY_METHOD_FUNC(dic_has_word), 1);
				rb_define_singleton_method(mDictionary, "mem_usage", RUBY_METHOD_FUNC(dic_mem_usage), 0);

        /* A Token hold the text and related position information. */
        cToken = rb_define_class_under(mRMMSeg, "Token", rb_cObject);
        rb_undef_method(rb_singleton_class(cToken), "new");
        rb_define_method(cToken, "text", RUBY_METHOD_FUNC(tk_text), 0);
        rb_define_method(cToken, "start", RUBY_METHOD_FUNC(tk_start), 0);
        rb_define_method(cToken, "end", RUBY_METHOD_FUNC(tk_end), 0);
				rb_define_method(cToken, "cixing", RUBY_METHOD_FUNC(tk_cixing), 0);
				rb_define_method(cToken, "freq", RUBY_METHOD_FUNC(tk_freq), 0);

				/* 一些判断词性的方法 */
				rb_define_method(cToken, "cx_unkown", RUBY_METHOD_FUNC(tk_cx_unkown), 0);
				rb_define_method(cToken, "cx_noun", RUBY_METHOD_FUNC(tk_cx_noun), 0);
				rb_define_method(cToken, "cx_verb", RUBY_METHOD_FUNC(tk_cx_verb), 0);
				rb_define_method(cToken, "cx_adj", RUBY_METHOD_FUNC(tk_cx_adj), 0);
				rb_define_method(cToken, "cx_adv", RUBY_METHOD_FUNC(tk_cx_adv), 0);
				rb_define_method(cToken, "cx_clas", RUBY_METHOD_FUNC(tk_cx_clas), 0);
				rb_define_method(cToken, "cx_echo", RUBY_METHOD_FUNC(tk_cx_echo), 0);
				rb_define_method(cToken, "cx_stru", RUBY_METHOD_FUNC(tk_cx_stru), 0);
				rb_define_method(cToken, "cx_aux", RUBY_METHOD_FUNC(tk_cx_aux), 0);
				rb_define_method(cToken, "cx_coor", RUBY_METHOD_FUNC(tk_cx_coor), 0);
				rb_define_method(cToken, "cx_conj", RUBY_METHOD_FUNC(tk_cx_conj), 0);
				rb_define_method(cToken, "cx_suffix", RUBY_METHOD_FUNC(tk_cx_suffix), 0);
				rb_define_method(cToken, "cx_prefix", RUBY_METHOD_FUNC(tk_cx_prefix), 0);
				rb_define_method(cToken, "cx_ques", RUBY_METHOD_FUNC(tk_cx_ques), 0);
				rb_define_method(cToken, "cx_num", RUBY_METHOD_FUNC(tk_cx_num), 0);
				rb_define_method(cToken, "cx_idiom", RUBY_METHOD_FUNC(tk_cx_idiom), 0);
				rb_define_method(cToken, "cx_game", RUBY_METHOD_FUNC(tk_cx_game), 0);

        /* An Algorithm object use the MMSEG algorithm to do segmenting. */
        cAlgorithm = rb_define_class_under(mRMMSeg, "Algorithm", rb_cObject);
        rb_define_singleton_method(cAlgorithm, "new", RUBY_METHOD_FUNC(algor_create), 1);
        rb_define_method(cAlgorithm, "next_token", RUBY_METHOD_FUNC(algor_next_token), 0);
    }
}
