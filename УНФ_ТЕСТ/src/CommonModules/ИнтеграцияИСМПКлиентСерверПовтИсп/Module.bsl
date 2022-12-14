#Область ПрограммныйИнтерфейс

// Возвращает дату обязательной маркировки маркируемой продукци переданного вида.
// 
// Параметры:
//  ВидМаркируемойПродукции - ПеречислениеСсылка.ВидыПродукцииИС - вид маркируемой продукции
// Возвращаемое значение:
// 	Дата - дата обязательной маркировки маркируемой продукции.
//
Функция ДатаОбязательнойМаркировкиПродукции(ВидМаркируемойПродукции) Экспорт
	
	Возврат ИнтеграцияИСМПВызовСервера.ДатаОбязательнойМаркировкиПродукции(ВидМаркируемойПродукции);
	
КонецФункции

// Возвращает признак ведения учета маркируемой продукци переданного вида.
// 
// Параметры:
//  ВидМаркируемойПродукции - ПеречислениеСсылка.ВидыПродукцииИС - вид маркируемой продукции
// Возвращаемое значение:
// 	Булево - признак ведения учета маркируемой продукции переданного вида.
//
Функция ВестиУчетМаркируемойПродукции(ВидМаркируемойПродукции = Неопределено) Экспорт
	
	Возврат ИнтеграцияИСМПВызовСервера.ВестиУчетМаркируемойПродукции(ВидМаркируемойПродукции);
	
КонецФункции

//Возвращает виды маркируемой продукции по которым ведется учет.
// Параметры:
//  ПродукцияИСМП - Булево - Будет добавлена продукция ИСМП
//  ПродукцияМОТП - Булево - Будет добавлена продукция МОТП
//Возвращаемое значение:
//   ФиксированныйМассив Из ПеречислениеСсылка.ВидыПродукцииИС - виды маркируемой продукции.
//
Функция УчитываемыеВидыМаркируемойПродукции(ПродукцияИСМП = Истина, ПродукцияМОТП = Истина) Экспорт
	
	ВидыМаркируемойПродукции = ИнтеграцияИСМПВызовСервера.УчитываемыеВидыМаркируемойПродукции();
	
	Если ПродукцияИСМП И ПродукцияМОТП Тогда
		Возврат ВидыМаркируемойПродукции;
	КонецЕсли;
	
	ВидыПродукции = Новый Массив;
	
	Для Каждого ВидПродукции Из ВидыМаркируемойПродукции Цикл
		Если ПродукцияИСМП И ИнтеграцияИСКлиентСервер.ЭтоПродукцияИСМП(ВидПродукции)
			Или ПродукцияМОТП И ИнтеграцияИСКлиентСервер.ЭтоПродукцияМОТП(ВидПродукции) Тогда
			ВидыПродукции.Добавить(ВидПродукции);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(ВидыПродукции);
	
КонецФункции


// Проверяет необходимость обязательной регистрации оборота маркируемой продукции переданного вида на переданную дату.
// 
// Параметры:
//  ВидМаркируемойПродукции - ПеречислениеСсылка.ВидыПродукцииИС - вид маркируемой продукции
//  НаДату - Дата - дата оборота маркируемой продукции
// Возвращаемое значение:
//  Булево - Истина, если на переданную дату в системе установлен признак ведения учета по переданному виду маркируемой продукции.
//
Функция ОбязательнаяРегистрацияОборотаМаркируемойПродукции(ВидМаркируемойПродукции, НаДату) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ВидМаркируемойПродукции) Тогда
		Возврат Ложь;
	ИначеЕсли НЕ ИнтеграцияИСМПКлиентСерверПовтИсп.ВестиУчетМаркируемойПродукции(ВидМаркируемойПродукции) Тогда
		Возврат Ложь;
	Иначе
		Возврат НаДату >= ИнтеграцияИСМПКлиентСерверПовтИсп.ДатаОбязательнойМаркировкиПродукции(ВидМаркируемойПродукции);
	КонецЕсли;
	
КонецФункции

// Проверяет что регистрация оборота маркируемой продукции переданного вида производится в тестовом режиме на переданную дату.
// 
// Параметры:
//  ВидМаркируемойПродукции - ПеречислениеСсылка.ВидыПродукцииИС - вид маркируемой продукции
//  НаДату - Дата - дата оборота маркируемой продукции
// Возвращаемое значение:
//  Булево - Истина, если в системе установлен признак ведения учета по переданному виду маркируемой продукции и дата оборота менее даты обязательной регистрации.
//
Функция ТестоваяРегистрацияОборотаМаркируемойПродукции(ВидМаркируемойПродукции, НаДату) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ВидМаркируемойПродукции) Тогда
		Возврат Ложь;
	ИначеЕсли НЕ ИнтеграцияИСМПКлиентСерверПовтИсп.ВестиУчетМаркируемойПродукции(ВидМаркируемойПродукции) Тогда
		Возврат Ложь;
	Иначе
		Возврат НаДату < ИнтеграцияИСМПКлиентСерверПовтИсп.ДатаОбязательнойМаркировкиПродукции(ВидМаркируемойПродукции);
	КонецЕсли;
	
КонецФункции

//Возвращает виды маркируемой продукции в тестовом режиме на переданную дату.
//
//Параметры:
//   НаДату - Дата - дата оборота маркируемой продукции
//
//Возвращаемое значение:
//   ФиксированныйМассив Из ПеречислениеСсылка.ВидыПродукцииИС - виды маркируемой продукции, по которым установлен 
//   признак ведения учета и дата оборота менее даты обязательной регистрации.
//
Функция ВидыПродукцииТестовогоПериода(НаДату) Экспорт
	
	Возврат ИнтеграцияИСМПВызовСервера.УчитываемыеВидыМаркируемойПродукции(НаДату, Истина);
	
КонецФункции

//Возвращает виды маркируемой продукции в тестовом режиме на переданную дату.
//
//Параметры:
//   НаДату - Дата - дата оборота маркируемой продукции
//
//Возвращаемое значение:
//   ФиксированныйМассив Из ПеречислениеСсылка.ВидыПродукцииИС - виды маркируемой продукции, по которым установлен 
//   признак ведения учета и дата оборота менее даты обязательной регистрации.
//
Функция ВидыПродукцииОбязательнойМаркировки(НаДату) Экспорт
	
	Возврат ИнтеграцияИСМПВызовСервера.УчитываемыеВидыМаркируемойПродукции(НаДату, Ложь);
	
КонецФункции

//Возвращает признак необходимости контроля статусов кодов маркировок ИС МП.
//
//Возвращаемое значение:
//   Булево - Истина, в случае необходимости контроля статусов
//
Функция КонтролироватьСтатусыКодовМаркировки() Экспорт
	
	Возврат ИнтеграцияИСМПВызовСервера.КонтролироватьСтатусыКодовМаркировки();

КонецФункции

//Возвращает признак необходимости контроля статусов кодов маркировок ИС МП при розничной торговле.
//
//Возвращаемое значение:
//   Булево - Истина, в случае необходимости контроля статусов.
//
Функция КонтролироватьСтатусыКодовМаркировкиВРознице() Экспорт
	
	Возврат ИнтеграцияИСМПВызовСервера.КонтролироватьСтатусыКодовМаркировкиВРознице();

КонецФункции

//Возвращает признак наличия типа метаданных конфигурации в типе реквизита "ДокументОснование"
//   Наличие типа означает то, что документ может иметь документ-основание.
//
//Возвращаемое значение:
//   Булево - Истина, если документ может иметь документ-основание.
//
Функция ДокументМожетИметьДокументОснование(ПолноеИмяМетаданных) Экспорт

	Возврат ИнтеграцияИСМПВызовСервера.ДокументМожетИметьДокументОснование(ПолноеИмяМетаданных);

КонецФункции

// Определяет признак учета в системе МРЦ.
// 
// Возвращаемое значение:
// 	Булево - Включено ведение учетаю
Функция УчитыватьМРЦ() Экспорт
	
	Возврат ИнтеграцияИСМПВызовСервера.НастройкиСканированияКодовМаркировки().УчитыватьМРЦ;
	
КонецФункции
	
#КонецОбласти