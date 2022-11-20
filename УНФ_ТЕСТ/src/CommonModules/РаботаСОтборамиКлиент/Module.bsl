
#Область ПрограммныйИнтерфейс

// Процедура - Обработчик нажатия на представление периода в панели отборов. Открывает форму выбора стандартного периода
//             и обрабатывает результат.
//
// Параметры:
//  Форма							 - УправляемаяФорма		 - Форма с панелью отборов
//  ИмяСпискаОтбора					 - Строка				 - Имя элемента формы - списка
//  ИмяПоляОтбора					 - Строка				 - Имя поля отбора периода
//  СтруктураИменЭлементов			 - Структура			 - Структура соответствия имен полей и фильтров  
//  УстановитьОтбор					 - Булево				 - Признак необходимости установки отбора списка
//  ОписаниеОповещенияОВыбореПериода - ОписаниеОповещения	 - Описание оповещения завершения выбора периода, если требуется нестандартная обработка
//
Процедура ПредставлениеПериодаВыбратьПериод(Форма, ИмяСпискаОтбора="Список", ИмяПоляОтбора="Дата", СтруктураИменЭлементов = Неопределено, УстановитьОтбор = Истина, ОписаниеОповещенияОВыбореПериода = Неопределено) Экспорт
	
	Параметры = Новый Структура("Форма, ИмяСпискаОтбора, ИмяПоляОтбора", Форма, ИмяСпискаОтбора, ИмяПоляОтбора);
	Если НЕ (СтруктураИменЭлементов = Неопределено) Тогда
		Параметры.Вставить("СтруктураИменЭлементов", СтруктураИменЭлементов);
	КонецЕсли;
	
	Если ОписаниеОповещенияОВыбореПериода <> Неопределено Тогда
		Параметры.Вставить("ОписаниеОповещенияОВыбореПериода",ОписаниеОповещенияОВыбореПериода);
	КонецЕсли;
	
	Параметры.Вставить("УстановитьОтбор", УстановитьОтбор);
	
	Оповещение = Новый ОписаниеОповещения("ПредставлениеПериодаНажатиеЗавершение", ЭтотОбъект, Параметры);
	
	Диалог = Новый ДиалогРедактированияСтандартногоПериода;
	Если СтруктураИменЭлементов = Неопределено Тогда
		Диалог.Период = Форма.ОтборПериод;
	Иначе
		Диалог.Период = Форма[СтруктураИменЭлементов.ОтборПериод];
	КонецЕсли;
	Диалог.Показать(Оповещение);
	
КонецПроцедуры

// Процедура - Сворачивает или разворачивает панель отборов формы
//
// Параметры:
//  Форма					 - УправляемаяФорма	 - Форма с панелью отборов
//  Видимость				 - Булево			 - Новое значение видимости панели
//  СтруктураИменЭлементов	 - Структура		 - Структура соответствия имен полей и фильтров
//  пШирина					 - Число			 - Ширина панели
//
Процедура СвернутьРазвернутьПанельОтборов(Форма, Видимость, СтруктураИменЭлементов = Неопределено, пШирина = 25) Экспорт
	
	ИнтерфейсТакси = Истина;
	#Если ВебКлиент ИЛИ МобильныйКлиент Тогда
	ИнтерфейсТакси = (ТекущийВариантИнтерфейсаКлиентскогоПриложения() = ВариантИнтерфейсаКлиентскогоПриложения.Такси);
	#КонецЕсли

	Если СтруктураИменЭлементов = Неопределено Тогда
		Форма.Элементы.ФильтрыНастройкиИДопИнфо.Видимость	= Видимость;
		Форма.Элементы.ДекорацияРазвернутьОтборы.Видимость	= НЕ Видимость;
		Форма.Элементы.ПраваяПанель.Ширина = ?(Видимость, ?(ИнтерфейсТакси, пШирина, пШирина-1), 0);
	Иначе
		Форма.Элементы[СтруктураИменЭлементов.ФильтрыНастройкиИДопИнфо].Видимость	= Видимость;
		Форма.Элементы[СтруктураИменЭлементов.ДекорацияРазвернутьОтборы].Видимость = НЕ Видимость;
		Форма.Элементы[СтруктураИменЭлементов.ПраваяПанель].Ширина = ?(Видимость, ?(ИнтерфейсТакси, пШирина, пШирина-1), 0);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПредставлениеПериодаНажатиеЗавершение(НовыйПериод, Параметры) Экспорт
	
	Если НовыйПериод = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Форма			= Параметры.Форма;
	ИмяСпискаОтбора = Параметры.ИмяСпискаОтбора;
	ИмяПоляОтбора	= Параметры.ИмяПоляОтбора;
	
	Если Параметры.Свойство("СтруктураИменЭлементов") Тогда
	
		Если ТипЗнч(НовыйПериод)=Тип("СтандартныйПериод") Тогда
			Форма[Параметры.СтруктураИменЭлементов.ОтборПериод] = НовыйПериод;
		ИначеЕсли ТипЗнч(НовыйПериод)=Тип("Дата") Тогда
			Форма[Параметры.СтруктураИменЭлементов.ОтборПериод].ДатаОкончания = НовыйПериод;
		КонецЕсли;
		
		Форма[Параметры.СтруктураИменЭлементов.ПредставлениеПериода] = РаботаСОтборамиКлиентСервер.ОбновитьПредставлениеПериода(Форма[Параметры.СтруктураИменЭлементов.ОтборПериод]);
		Если Параметры.УстановитьОтбор Тогда
			РаботаСОтборамиКлиентСервер.УстановитьОтборПоПериоду(
				Форма[ИмяСпискаОтбора].КомпоновщикНастроек.Настройки.Отбор, 
				Форма[Параметры.СтруктураИменЭлементов.ОтборПериод].ДатаНачала, 
				Форма[Параметры.СтруктураИменЭлементов.ОтборПериод].ДатаОкончания, ИмяПоляОтбора);
		КонецЕсли;
		
		Если Параметры.СтруктураИменЭлементов.Свойство("СобытиеОповещения") Тогда
			Оповестить(Параметры.СтруктураИменЭлементов.СобытиеОповещения);
		КонецЕсли;
			
	Иначе
		
		Если ТипЗнч(НовыйПериод)=Тип("СтандартныйПериод") Тогда
			Форма.ОтборПериод = НовыйПериод;
		ИначеЕсли ТипЗнч(НовыйПериод)=Тип("Дата") Тогда
			Форма.ОтборПериод.ДатаОкончания = НовыйПериод;
		КонецЕсли;
		
		Форма.ПредставлениеПериода = РаботаСОтборамиКлиентСервер.ОбновитьПредставлениеПериода(Форма.ОтборПериод);
		Если Параметры.УстановитьОтбор Тогда
			РаботаСОтборамиКлиентСервер.УстановитьОтборПоПериоду(Форма[ИмяСпискаОтбора].КомпоновщикНастроек.Настройки.Отбор, Форма.ОтборПериод.ДатаНачала, Форма.ОтборПериод.ДатаОкончания, ИмяПоляОтбора);
		КонецЕсли;
		
		Если Параметры.Свойство("ОписаниеОповещенияОВыбореПериода") Тогда
			Оповестить(Параметры.ОписаниеОповещенияОВыбореПериода);
		КонецЕсли;
	КонецЕсли;
	
	#Если ВебКлиент ИЛИ МобильныйКлиент Тогда
		Форма.ОбновитьОтображениеДанных();
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма.Элементы, "ПраваяПанель") Тогда
			Если Параметры.Свойство("СтруктураИменЭлементов") Тогда
				ИмяПараметраОтборПериод = Параметры.СтруктураИменЭлементов.ОтборПериод;
			Иначе
				ИмяПараметраОтборПериод = "ОтборПериод";
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Форма[ИмяПараметраОтборПериод]) Тогда
				Форма.Элементы.ПраваяПанель.Заголовок = НСтр("ru = 'Отборы (установлены)'");
			Иначе
				Форма.Элементы.ПраваяПанель.Заголовок = НСтр("ru = 'Отборы'");
			КонецЕсли;
		КонецЕсли;
	#КонецЕсли

КонецПроцедуры

#КонецОбласти 


 

  



