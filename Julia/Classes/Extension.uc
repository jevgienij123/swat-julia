class Extension extends SwatGame.SwatMutator;

/**
 * Copyright (c) 2014 Sergei Khoroshilov <kh.sergei@gmail.com>
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

/**
 * Extension version
 * @type string
 */
var string Version;

/**
 * Extension title
 * @type string
 */
var string Title;

/**
 * Reference to the Core superobject
 * @type class'Core'
 */
var Core Core;

/**
 * Reference to the extension's Locale instance
 * @type class'Locale'
 */
var Locale Locale;

/**
 * @type class<Locale>
 */
var class<Locale> LocaleClass;

/**
 * Indicate whether an extension is enabled
 * @type bool
 */
var config bool Enabled;

/**
 * Check whether the extension is disabled
 * 
 * @return  void
 */
public function PreBeginPlay()
{
    Super.PreBeginPlay();
    self.Disable('Tick');

    if (Level.NetMode == NM_ListenServer || Level.NetMode == NM_DedicatedServer)
    {
        if (Level.Game != None && SwatGameInfo(Level.Game) != None)
        {
            if (self.Enabled)
            {
                return;
            }
        }
    }
    self.Destroy();
}

/**
 * Get the reference to the Julia's Core instance
 * 
 * @return  void
 */
public function BeginPlay()
{
    Super.BeginPlay();

    self.Core = self.GetCoreInstance();

    if (self.Core == None)
    {
        log(self $ " was unable to find the Julia.Core instance");
        self.Destroy();
    }

    if (self.LocaleClass != None)
    {
        self.Locale = Spawn(self.LocaleClass);
    }

    log("Julia/" $ self.Title $ " (version " $ self.Version $ ") has been initialized");

    self.SetTimer(class'Core'.const.DELTA, true);
}

/**
 * Attempt to find the Julia's Core instance in the list of server actors
 * 
 * @return  class'Core'
 */
protected function Core GetCoreInstance()
{
    local Core Core;

    foreach DynamicActors(class'Julia.Core', Core)
    {
        return Core;
    }
    return None;
}

/**
 * Return the extension title
 * 
 * @return  string
 */
final public function string GetTitle()
{
    return self.Title;
}

/**
 * Return the extension version
 * 
 * @return  string
 */
final public function string GetVersion()
{
    return self.Version;
}

event Destroyed()
{
    self.Core = None;
    self.LocaleClass = None;

    if (self.Locale != None)
    {
        self.Locale.Destroy();
        self.Locale = None;
    }

    log(self $ ": Julia/" $ self.Title $ " is about to be destroyed");

    Super.Destroyed();
}

defaultproperties
{
    Title="undefined";
    Version="unknown";
    LocaleClass=None;
}

/* vim: set ft=java: */