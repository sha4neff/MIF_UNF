
#Область ОбменСБП20

// Процедура-обработчик события "ПередЗаписью" ссылочных типов данных (кроме документов) для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - источник события, кроме типа ДокументОбъект
//  Отказ          - Булево - флаг отказа от выполнения обработчика
// 
Процедура ОбменДаннымиОбменУправлениеНебольшойФирмойБухгалтерия20ПередЗаписью(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью("ОбменУправлениеНебольшойФирмойБухгалтерия20", Источник, Отказ);
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" документов для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - ДокументОбъект - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
// 
Процедура ОбменДаннымиОбменУправлениеНебольшойФирмойБухгалтерия20ПередЗаписьюДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюДокумента("ОбменУправлениеНебольшойФирмойБухгалтерия20", Источник, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" регистров для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - НаборЗаписейРегистра - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
//  Замещение      - Булево - признак замещения существующего набора записей
// 
Процедура ОбменДаннымиОбменУправлениеНебольшойФирмойБухгалтерия20ПередЗаписьюРегистра(Источник, Отказ, Замещение) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра("ОбменУправлениеНебольшойФирмойБухгалтерия20", Источник, Отказ, Замещение);
	
КонецПроцедуры

// Процедура-обработчик события "ПередУдалением" ссылочных типов данных для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
// 
Процедура ОбменДаннымиОбменУправлениеНебольшойФирмойБухгалтерия20ПередУдалением(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением("ОбменУправлениеНебольшойФирмойБухгалтерия20", Источник, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбменСБП30

// Процедура-обработчик события "ПередЗаписью" ссылочных типов данных (кроме документов) для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - источник события, кроме типа ДокументОбъект
//  Отказ          - Булево - флаг отказа от выполнения обработчика
// 
Процедура ОбменУправлениеНебольшойФирмойБухгалтерия30ПередЗаписью(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью("ОбменУправлениеНебольшойФирмойБухгалтерия30", Источник, Отказ);
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" документов для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - ДокументОбъект - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
// 
Процедура ОбменУправлениеНебольшойФирмойБухгалтерия30ПередЗаписьюДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюДокумента("ОбменУправлениеНебольшойФирмойБухгалтерия30", Источник, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" регистров для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - НаборЗаписейРегистра - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
//  Замещение      - Булево - признак замещения существующего набора записей
// 
Процедура ОбменУправлениеНебольшойФирмойБухгалтерия30ПередЗаписьюРегистра(Источник, Отказ, Замещение) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра("ОбменУправлениеНебольшойФирмойБухгалтерия30", Источник, Отказ, Замещение);
	
КонецПроцедуры

// Процедура-обработчик события "ПередУдалением" ссылочных типов данных для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
// 
Процедура ОбменУправлениеНебольшойФирмойБухгалтерия30ПередУдалением(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением("ОбменУправлениеНебольшойФирмойБухгалтерия30", Источник, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбменЧерезУниверсальныйФормат

// Процедура-обработчик события "ПередЗаписью" ссылочных типов данных (кроме документов) для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - источник события, кроме типа ДокументОбъект
//  Отказ          - Булево - флаг отказа от выполнения обработчика
// 
Процедура СинхронизацияДанныхЧерезУниверсальныйФорматПередЗаписью(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью("СинхронизацияДанныхЧерезУниверсальныйФормат", Источник, Отказ);
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" документов для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - ДокументОбъект - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
// 
Процедура СинхронизацияДанныхЧерезУниверсальныйФорматПередЗаписьюДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюДокумента("СинхронизацияДанныхЧерезУниверсальныйФормат", Источник, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

// Процедура-обработчик события "ПередУдалением" ссылочных типов данных для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
// 
Процедура СинхронизацияДанныхЧерезУниверсальныйФорматПередУдалением(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением("СинхронизацияДанныхЧерезУниверсальныйФормат", Источник, Отказ);
	
КонецПроцедуры

Процедура СинхронизацияДанныхЧерезУниверсальныйФорматПередЗаписьюРегистра(Источник, Отказ, Замещение) Экспорт
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра("СинхронизацияДанныхЧерезУниверсальныйФормат", Источник, Отказ, Замещение);
КонецПроцедуры

#КонецОбласти
