/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2014-2015 Lars Birkemose
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

// -----------------------------------------------------------------------

uniform float u_textureMixEnabled;
uniform highp float u_textureMix;

void main()
{
    if (u_textureMixEnabled != 0.0)
    {
        vec4 tex1 = texture2D(cc_MainTexture, cc_FragTexCoord1);
        vec4 tex2 = texture2D(cc_MainTexture, cc_FragTexCoord2);
        gl_FragColor = cc_FragColor * mix(tex2, tex1, u_textureMix);
    }
    else
    {
        gl_FragColor = cc_FragColor * texture2D(cc_MainTexture, cc_FragTexCoord1);
    }
}

// -----------------------------------------------------------------------

