/*
 * Author: Richard Lord
 * Copyright (c) Big Room Ventures Ltd. 2008
 * Version: 1.0.0
 * 
 * Licence Agreement
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package cn.itamt.utils {
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;			

	/**
	 * Manages objects by retaining disposed objects and returning them when a new object
	 * is requested, to avoid unecessary object creation and disposal and so avoid
	 * unnecessary object creation and garbage collection.
	 */
	public class ObjectPool {
		private static var pools : Dictionary = new Dictionary();

		private static function getPool( type : Class ) : Array {
			return type in pools ? pools[type] : pools[type] = new Array();
		}

		/**
		 * Get an object of the specified type. If such an object exists in the pool then 
		 * it will be returned. If such an object doesn't exist, a new one will be created.
		 * 
		 * @param type The type of object required.
		 * @param parameters If there are no instances of the object in the pool, a new one
		 * will be created and these parameters will be passed to the object constrictor.
		 * Because you can't know if a new object will be created, you can't rely on these 
		 * parameters being used. They are here to enable pooling of objects that require
		 * parameters in their constructor.
		 */
		public static function getObject( type : Class, ...parameters ) : * {
			var pool : Array = getPool(type);
			if( pool.length > 0 ) {
				return pool.pop();
			} else {
				return construct(type, parameters);
			}
		}

		/**
		 * Return an object to the pool for retention and later reuse. Note that the object
		 * still exists, so you need to clean up any event listeners etc. on the object so 
		 * that the events stop occuring.
		 * 
		 * @param object The object to return to the object pool.
		 * @param type The type of the object. If you don't indicate the object type then the
		 * object is inspected to find its type. This is a little slower than specifying the 
		 * type yourself.
		 */
		public static function disposeObject( object : *, type : Class = null ) : void {
			if( !type ) {
				var typeName : String = getQualifiedClassName(object);
				type = getDefinitionByName(typeName) as Class;
			}
			var pool : Array = getPool(type);
			pool.push(object);
		}

		/**
		 * This function is used to construct an object from the class and an array of parameters.
		 * 
		 * @param type The class to construct.
		 * @param parameters An array of up to ten parameters to pass to the constructor.
		 */
		public static function construct( type : Class, parameters : Array ) : * {
			switch( parameters.length ) {
				case 0:
					return new type();
				case 1:
					return new type(parameters[0]);
				case 2:
					return new type(parameters[0], parameters[1]);
				case 3:
					return new type(parameters[0], parameters[1], parameters[2]);
				case 4:
					return new type(parameters[0], parameters[1], parameters[2], parameters[3]);
				case 5:
					return new type(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4]);
				case 6:
					return new type(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5]);
				case 7:
					return new type(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6]);
				case 8:
					return new type(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7]);
				case 9:
					return new type(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8]);
				case 10:
					return new type(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9]);
				default:
					return null;
			}
		}
	}
}
